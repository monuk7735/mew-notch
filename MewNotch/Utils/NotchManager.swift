//
//  NotchManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/03/25.
//

import SwiftUI
import MacroVisionKit

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
        removeListenerForScreenUpdates()
    }
    
    @MainActor
    private func updateFullScreenStatus(with spaces: [MacroVisionKit.FullScreenMonitor.SpaceInfo]) {
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
    
    @objc func refreshNotches(
        killAllWindows: Bool = false,
        addToSeparateSpace: Bool = true
    ) {
        
        let shownOnDisplays = Set(notchDefaults.shownOnDisplay.filter { $1 }.keys)
        
        let shouldShowOnScreen: (NSScreen) -> Bool = { [weak self] screen in
            guard let self else { return false }
            
            if self.notchDefaults.notchDisplayVisibility != .Custom {
                return true
            }
            
            return shownOnDisplays.contains(screen.localizedName)
        }
        
        windows.forEach { screen, window in
            if killAllWindows || !NSScreen.screens.contains(
                where: { $0 == screen}
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
            
            panel.orderFrontRegardless()
            
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
    
    func removeListenerForScreenUpdates() {
        NotificationCenter.default.removeObserver(self)
    }
}
