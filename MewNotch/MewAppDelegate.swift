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
        UserDefaults.standard.removeObject(forKey: "NSWindow Frame com_apple_SwiftUI_Settings_window")
        UserDefaults.standard.removeObject(forKey: "NSSplitView Subview Frames com_apple_SwiftUI_Settings_window, SidebarNavigationSplitView")
        
        if AppDefaults.shared.disableSystemHUD {
            MediaKeyManager.shared.start()
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
        MediaKeyManager.shared.stop()
        
        return .terminateNow
    }
}
