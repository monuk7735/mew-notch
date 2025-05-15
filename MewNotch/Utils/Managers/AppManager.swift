//
//  AppManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 02/04/25.
//

class AppManager {
    
    static let shared = AppManager()
    
    private init() {}
    
    func kill() {
        NSApplication.shared.terminate(nil)
    }
    
    func restart(
        killPreviousInstance: Bool = true
    ) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        
        let workspace = NSWorkspace.shared
        
        if let appURL = workspace.urlForApplication(
            withBundleIdentifier: bundleIdentifier
        ) {
            let configuration = NSWorkspace.OpenConfiguration()
            
            configuration.createsNewApplicationInstance = killPreviousInstance
            
            workspace.openApplication(
                at: appURL,
                configuration: configuration
            )
        }
        
        if killPreviousInstance {
            NSApplication.shared.terminate(nil)
        }
    }
}
