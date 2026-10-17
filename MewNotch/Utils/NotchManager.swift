//
//  NotchManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/03/25.
//

import MacroVisionKit
import SwiftUI

class NotchManager {
    static let shared = NotchManager()

    var notchDefaults: NotchDefaults = .shared

    var windows: [NSScreen: NSWindow] = [:]

    private var monitorTask: Task<Void, Never>?

    private init() {
        monitorTask = Task { @MainActor in
            let stream = await FullScreenMonitor.shared.spaceChanges()
            for await spaces in stream {
                self.updateFullScreenStatus(with: spaces)
            }
        }

        addListenerForScreenUpdates()
    }

    deinit {
        monitorTask?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    @MainActor
    private func updateFullScreenStatus(with spaces: [MacroVisionKit.FullScreenMonitor.SpaceInfo]) {
        guard notchDefaults.hideOnFullScreen else { return }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.6
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            windows.forEach { $0.value.animator().alphaValue = 1 }
        }

        for space in spaces {
            if let screen = FullScreenMonitor.shared.screen(for: space) {
                windows[screen]?.alphaValue = 0
            }
        }
    }

    private var hideWorkItems: [NSScreen: DispatchWorkItem] = [:]

    func showAuxiliaryWindow(for screen: NSScreen) {
        hideWorkItems[screen]?.cancel()
        hideWorkItems.removeValue(forKey: screen)
        guard let panel = windows[screen], !NotchUtils.shared.hasNotch(screen: screen) else { return }
        panel.orderFrontRegardless()
    }

    func hideAuxiliaryWindow(for screen: NSScreen, delay: TimeInterval = 0.4) {
        hideWorkItems[screen]?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self, let panel = windows[screen] else { return }
            panel.orderOut(nil)
            hideWorkItems.removeValue(forKey: screen)
        }
        hideWorkItems[screen] = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    func shouldShowOnScreen(_ screen: NSScreen) -> Bool {
        let shownOnDisplays = Set(notchDefaults.shownOnDisplay.filter { $1 }.keys)

        switch notchDefaults.notchDisplayVisibility {
        case .allDisplays:
            return true
        case .notchedDisplayOnly:
            return NotchUtils.shared.hasNotch(screen: screen)
        case .custom:
            return shownOnDisplays.contains(screen.localizedName)
        }
    }

    @objc func refreshNotches(
        killAllWindows: Bool = false,
        addToSeparateSpace: Bool = true
    ) {
        for (screen, window) in windows {
            if killAllWindows || !NSScreen.screens.contains(
                where: { $0 == screen }
            ) || !shouldShowOnScreen(screen) {
                window.close()

                windows.removeValue(
                    forKey: screen
                )
            }
        }

        NSScreen.screens.filter {
            shouldShowOnScreen($0)
        }.forEach { screen in
            var panel: NSWindow! = windows[screen]

            if panel == nil {
                let view: NSView = NSHostingView(
                    rootView: NotchView(
                        screen: screen
                    )
                )

                panel = MewPanel(
                    contentRect: screen.frame,
                    styleMask: [
                        .borderless,
                        .nonactivatingPanel,
                        .utilityWindow,
                        .hudWindow
                    ],
                    backing: .buffered,
                    defer: true
                )

                panel.contentView = view
            }

            panel.setFrame(
                screen.frame,
                display: true
            )

            let isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)
            if isHardwareNotched {
                panel.orderFrontRegardless()
            } else {
                panel.orderOut(nil)
            }

            windows[screen] = panel

            if addToSeparateSpace {
                if notchDefaults.shownOnLockScreen {
                    WindowManager.shared?.moveToLockScreen(panel)
                } else {
                    NotchSpaceManager.shared.notchSpace.windows.insert(panel)
                }
            }
        }

        // Trigger manual update based on current state
        Task { @MainActor in
            let spaces = await FullScreenMonitor.shared.detectFullscreenApps()
            self.updateFullScreenStatus(with: spaces)
        }
    }

    func addListenerForScreenUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshNotches),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
}
