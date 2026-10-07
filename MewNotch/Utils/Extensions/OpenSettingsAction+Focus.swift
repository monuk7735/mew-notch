//
//  OpenSettingsAction+Focus.swift
//  MewNotch
//

import AppKit
import SwiftUI

extension OpenSettingsAction {
    
    /// Opens the Settings window and brings it to the front.
    ///
    /// MewNotch runs as an accessory app (`LSUIElement` in Info.plist), so the
    /// system does not activate the app when one of its windows opens. Calling
    /// `openSettings()` on its own therefore leaves the settings window behind
    /// whatever app is currently in front.
    ///
    /// Activate explicitly, then raise the window once SwiftUI has created it.
    func callAsFunctionBringingToFront() {
        self.callAsFunction()
        
        NSRunningApplication.current.activate(options: [.activateAllWindows])
        
        DispatchQueue.main.async {
            if let window = NSApp.windows.first(
                where: { $0.isVisible && $0.canBecomeKey }
            ) {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
}
