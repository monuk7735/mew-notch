//
//  OSDUIManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Foundation

class OSDUIManager {
    
    static let shared = OSDUIManager()
    
//    private var timer: Timer?
    
    private init() { }

    public func start() {
        do {
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-9", "OSDUIHelper"]
            
            try task.run()
            
            removeObservers()
        } catch {
            NSLog("Error while trying to re-enable OSDUIHelper. \(error)")
        }
    }

    public func stop() {
        do {
            let kickstart = Process()
            
            kickstart.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            
            // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
            
            kickstart.arguments = ["kickstart", "gui/\(getuid())/com.apple.OSDUIHelper"]
            
            try kickstart.run()
            kickstart.waitUntilExit()
            
            usleep(500000) // Wait a bit
            
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-STOP", "OSDUIHelper"]
            
            try task.run()
            
            startObservers()
        } catch {
            NSLog("Error while trying to hide OSDUIHelper. Please create an issue on GitHub. Error: \(error)")
        }
    }
    
    public func reset() {
        start()
        
        stop()
    }
    
    func startObservers() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(lidStateChanged(_:)),
            name: NSWorkspace.screensDidWakeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveWakeNote(_:)),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    func removeObservers() {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func lidStateChanged(
        _ notification: Notification
    ) {
        self.reset()
    }
    
    @objc func receiveWakeNote(
        _ notification: Notification
    ) {
        self.reset()
    }
}
