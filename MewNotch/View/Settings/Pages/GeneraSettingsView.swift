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
                            OSDUIManager.shared.stop()
                        } else {
                            OSDUIManager.shared.start()
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
