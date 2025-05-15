//
//  NotchManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/03/25.
//

import SwiftUI

class NotchManager {
    
    static let shared = NotchManager()
    
    var notchDefaults: NotchDefaults = .shared
    
    private init() {
        addListenerForScreenUpdates()
    }
    
    deinit {
        removeListenerForScreenUpdates()
    }
    
    @objc func refreshNotches() {
        
        let shownOnDisplays = Set(notchDefaults.shownOnDisplay.filter { $1 }.keys)
        
        let shouldShowOnScreen: (NSScreen) -> Bool = { [weak self] screen in
            guard let self else { return false }
            
            if self.notchDefaults.notchDisplayVisibility != .Custom {
                return true
            }
            
            return shownOnDisplays.contains(screen.localizedName)
        }
        
        NSApplication.shared.windows.forEach { window in
            window.close()
            
            NotchSpaceManager.shared.notchSpace.windows
                .remove(
                    window
                )
        }
        
        NSScreen.screens.filter {
            shouldShowOnScreen($0)
        }.forEach { screen in
            let view: NSView = NSHostingView(
                rootView: NotchView(
                    screen: screen
                )
            )
            
            let panel = MewPanel(
                contentRect: .zero,
                styleMask: [
                    .borderless,
                    .nonactivatingPanel
                ],
                backing: .buffered,
                defer: true
            )
            
            panel.contentView = view
            
            panel.setFrame(
                screen.frame,
                display: true
            )
            
            panel.orderFrontRegardless()
            
            NotchSpaceManager.shared.notchSpace.windows.insert(panel)
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
