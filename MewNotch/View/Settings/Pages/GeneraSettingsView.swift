//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI
import LaunchAtLogin

struct GeneraSettingsView: View {
    
    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var settingsViewModel: SettingsViewModel = .init()
    
    var body: some View {
        Form {
            Section(
                content: {
                    LaunchAtLogin.Toggle()
                    
                    Toggle(
                        isOn: $appDefaults.showMenuIcon
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Status Icon")
                            
                            Text("Shown in Menu Bar for easy access")
                                .font(.footnote)
                        }
                    }
                },
                header: {
                    Text("App")
                }
            )
            
            Section(
                content: {
                    VStack(alignment: .leading) {
                        Toggle(
                            isOn: $appDefaults.disableSystemHUD
                        ) {
                            VStack(
                                alignment: .leading
                            ) {
                                Text("Disable system HUD")
                            }
                        }
                        .onChange(
                            of: appDefaults.disableSystemHUD
                        ) { _, newValue in
                            if newValue {
                                if !AXIsProcessTrusted() {
                                    // If not trusted, we can't block events.
                                    // The MediaKeyManager will fail to start the tap.
                                    // We should prompt the user.
                                    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                                    AXIsProcessTrustedWithOptions(options as CFDictionary)
                                }
                                MediaKeyManager.shared.start()
                            } else {
                                MediaKeyManager.shared.stop()
                            }
                        }
                        
                        if appDefaults.disableSystemHUD && !AXIsProcessTrusted() {
                            Text("Accessibility permissions are required to hide the system HUD.")
                                .font(.caption)
                                .foregroundColor(.red)
                            
                            Button("Open System Settings") {
                                let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                                AXIsProcessTrustedWithOptions(options as CFDictionary)
                            }
                        }
                    }
                },
                header: {
                    Text("System")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .toolbar {
            ToolbarItem(
                placement: .automatic
            ) {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
    }
}

#Preview {
    GeneraSettingsView()
}
