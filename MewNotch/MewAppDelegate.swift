//
//  MewAppDelegate.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

class MewAppDelegate: NSObject, NSApplicationDelegate {
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.openSettings) var openSettingsWindow
    
    private var timer: Timer? = nil
    
    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return false
    }
    
    func applicationWillTerminate(
        _ notification: Notification
    ) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationDidFinishLaunching(
        _ notification: Notification
    ) {
        if AppDefaults.shared.disableSystemHUD {
            OSDUIManager.shared.stop()
        }
        
        // Need to Initialise once to set system listeners
        AudioInput.sharedInstance()
        AudioOutput.sharedInstance()
        Brightness.sharedInstance()
        PowerStatus.sharedInstance()
        NowPlaying.shared.startListener()
        
        timer = .scheduledTimer(
            withTimeInterval: 30,
            repeats: false
        ) { _ in
            NotchManager.shared.refreshNotches(killAllWindows: true)
        }
        
        NotchManager.shared.refreshNotches(
            addToSeparateSpace: false
        )
        
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows: Bool
    ) -> Bool {
        if !hasVisibleWindows {
            openSettingsWindow.callAsFunction()
        }
        
        return !hasVisibleWindows
    }
    
    func applicationShouldTerminate(
        _ sender: NSApplication
    ) -> NSApplication.TerminateReply {
        timer?.invalidate()
        OSDUIManager.shared.start()
        
        return .terminateNow
    }
}
