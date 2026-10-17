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
    var lockScreenWindows: [NSScreen: NSWindow] = [:]

    private var monitorTask: Task<Void, Never>?
    private var isScreenLocked: Bool = false

    private init() {
        if let sessionDict = CGSessionCopyCurrentDictionary() as? [String: Any],
           let isLocked = sessionDict["CGSSessionScreenIsLocked"] as? Bool {
            isScreenLocked = isLocked
        }

        monitorTask = Task { @MainActor in
            let stream = await FullScreenMonitor.shared.spaceChanges()
            for await spaces in stream {
                self.updateFullScreenStatus(with: spaces)
            }
        }

        addListenerForScreenUpdates()
        addListenersForScreenLock()
    }

    deinit {
        monitorTask?.cancel()
        unlockWorkItem?.cancel()
        NotificationCenter.default.removeObserver(self)
        DistributedNotificationCenter.default().removeObserver(self)
    }

    private func addListenersForScreenLock() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleScreenLocked),
            name: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleScreenUnlocked),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
    }

    private var unlockWorkItem: DispatchWorkItem?

    @objc private func handleScreenLocked() {
        isScreenLocked = true
        unlockWorkItem?.cancel()
        unlockWorkItem = nil

        guard notchDefaults.shownOnLockScreen else { return }
        for (screen, window) in lockScreenWindows where NotchUtils.shared.hasNotch(screen: screen) {
            window.orderFrontRegardless()
        }
    }

    @objc private func handleScreenUnlocked() {
        isScreenLocked = false
        unlockWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self, !self.isScreenLocked else { return }
            for (_, window) in lockScreenWindows {
                window.orderOut(nil)
            }
            unlockWorkItem = nil
        }
        unlockWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: workItem)
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

    private var hideWorkItems: [NSWindow: DispatchWorkItem] = [:]

    func showAuxiliaryWindow(for screen: NSScreen, isLockScreen: Bool = false) {
        guard !NotchUtils.shared.hasNotch(screen: screen) else { return }
        guard let panel = isLockScreen ? lockScreenWindows[screen] : windows[screen] else { return }
        hideWorkItems[panel]?.cancel()
        hideWorkItems.removeValue(forKey: panel)
        panel.orderFrontRegardless()
    }

    func hideAuxiliaryWindow(for screen: NSScreen, isLockScreen: Bool = false, delay: TimeInterval = 0.4) {
        guard !NotchUtils.shared.hasNotch(screen: screen) else { return }
        guard let panel = isLockScreen ? lockScreenWindows[screen] : windows[screen] else { return }
        hideWorkItems[panel]?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            panel.orderOut(nil)
            hideWorkItems.removeValue(forKey: panel)
        }
        hideWorkItems[panel] = workItem
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

    private func removeStaleWindows(killAllWindows: Bool) {
        for (screen, window) in windows {
            if killAllWindows || !NSScreen.screens.contains(
                where: { $0 == screen }
            ) || !shouldShowOnScreen(screen) {
                window.close()
                NotchSpaceManager.shared.notchSpace.windows.remove(window)
                windows.removeValue(forKey: screen)
            }
        }

        for (screen, window) in lockScreenWindows {
            if killAllWindows || !notchDefaults.shownOnLockScreen || !NSScreen.screens.contains(
                where: { $0 == screen }
            ) || !shouldShowOnScreen(screen) {
                window.close()
                lockScreenWindows.removeValue(forKey: screen)
            }
        }
    }

    private func setupNormalWindow(for screen: NSScreen, isHardwareNotched: Bool, addToSeparateSpace: Bool) {
        var panel: NSWindow! = windows[screen]

        if panel == nil {
            let view: NSView = NSHostingView(
                rootView: NotchView(
                    screen: screen,
                    isLockScreen: false
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
                defer: false
            )

            panel.contentView = view
        }

        panel.setFrame(
            screen.frame,
            display: true
        )

        if isHardwareNotched {
            panel.orderFrontRegardless()
        } else {
            panel.orderOut(nil)
        }

        windows[screen] = panel

        if addToSeparateSpace {
            NotchSpaceManager.shared.notchSpace.windows.insert(panel)
        }
    }

    private func setupLockScreenWindow(for screen: NSScreen, isHardwareNotched: Bool, addToSeparateSpace: Bool) {
        var lockPanel: NSWindow! = lockScreenWindows[screen]

        if lockPanel == nil {
            let lockView: NSView = NSHostingView(
                rootView: NotchView(
                    screen: screen,
                    isLockScreen: true
                )
            )

            lockPanel = MewPanel(
                contentRect: screen.frame,
                styleMask: [
                    .borderless,
                    .nonactivatingPanel,
                    .utilityWindow,
                    .hudWindow
                ],
                backing: .buffered,
                defer: false
            )

            lockPanel.ignoresMouseEvents = true
            lockPanel.contentView = lockView
        }

        lockPanel.setFrame(
            screen.frame,
            display: true
        )

        lockScreenWindows[screen] = lockPanel

        if addToSeparateSpace {
            WindowManager.shared?.moveToLockScreen(lockPanel)
        }

        if isScreenLocked, isHardwareNotched {
            lockPanel.orderFrontRegardless()
        } else {
            lockPanel.orderOut(nil)
        }
    }

    @objc func refreshNotches(
        killAllWindows: Bool = false,
        addToSeparateSpace: Bool = true
    ) {
        removeStaleWindows(killAllWindows: killAllWindows)

        NSScreen.screens.filter {
            shouldShowOnScreen($0)
        }.forEach { screen in
            let isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)
            setupNormalWindow(for: screen, isHardwareNotched: isHardwareNotched, addToSeparateSpace: addToSeparateSpace)

            if notchDefaults.shownOnLockScreen {
                setupLockScreenWindow(for: screen, isHardwareNotched: isHardwareNotched, addToSeparateSpace: addToSeparateSpace)
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
