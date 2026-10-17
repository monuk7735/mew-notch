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

    private var timer: Timer?

    func applicationShouldTerminateAfterLastWindowClosed(
        _: NSApplication
    ) -> Bool {
        false
    }

    func applicationDidFinishLaunching(
        _: Notification
    ) {
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
        _: NSApplication,
        hasVisibleWindows: Bool
    ) -> Bool {
        if !hasVisibleWindows {
            openSettingsWindow.callAsFunctionBringingToFront()
        }

        return !hasVisibleWindows
    }

    func applicationShouldTerminate(
        _: NSApplication
    ) -> NSApplication.TerminateReply {
        timer?.invalidate()
        MediaKeyManager.shared.stop()

        return .terminateNow
    }
}
