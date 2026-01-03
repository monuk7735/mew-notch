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
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Launch at Login",
                    subtitle: "Automatically start MewNotch when you log in",
                    icon: "arrow.up.circle.fill",
                    color: .blue
                ) {
                    LaunchAtLogin.Toggle {
                        Text("")
                    }
                    .labelsHidden()
                }
                
                SettingsRow(
                    title: "Status Icon",
                    subtitle: "Show icon in menu bar for easy access",
                    icon: "menubar.rectangle",
                    color: .gray
                ) {
                    Toggle("", isOn: $appDefaults.showMenuIcon)
                }
            } header: {
                Text("App")
            }
            
            Section {
                SettingsRow(
                    title: "Disable System HUD",
                    subtitle: "Hide system volume and brightness overlays",
                    icon: "eye.slash.fill",
                    color: .red
                ) {
                    Toggle("", isOn: $appDefaults.disableSystemHUD)
                        .onChange(of: appDefaults.disableSystemHUD) { _, newValue in
                            if newValue {
                                if !AXIsProcessTrusted() {
                                    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                                    AXIsProcessTrustedWithOptions(options as CFDictionary)
                                }
                                MediaKeyManager.shared.start()
                            } else {
                                MediaKeyManager.shared.stop()
                            }
                        }
                }
                
                if appDefaults.disableSystemHUD && !AXIsProcessTrusted() {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Accessibility permissions are required.", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                        
                        Button("Open System Settings") {
                            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                            AXIsProcessTrustedWithOptions(options as CFDictionary)
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 44) // Indent to align with text
                }
            } header: {
                Text("System")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
    }
}

#Preview {
    GeneraSettingsView()
}
