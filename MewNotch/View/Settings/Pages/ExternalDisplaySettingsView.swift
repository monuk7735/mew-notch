//
//  ExternalDisplaySettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct ExternalDisplaySettingsView: View {
    @StateObject var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Show HUD on External Displays",
                    subtitle: "Show display-targeted brightness alerts on secondary displays; otherwise falls back to main display",
                    icon: .display,
                    color: AppColor.notch
                ) {
                    Toggle("", isOn: $notchDefaults.showHUDOnAuxiliaryScreens)
                }
            } header: {
                Text("HUD Alerts")
            }

            Section {
                SettingsRow(
                    title: "Lock Screen Alerts",
                    subtitle: "Lock and unlock status alerts are displayed across all connected monitors",
                    icon: .lock,
                    color: AppColor.lock
                ) {
                    Text("Always On")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                SettingsRow(
                    title: "BetterDisplay Support",
                    subtitle: "Targeted brightness adjustments via BetterDisplay appear on the corresponding monitor",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Text("Supported")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Features")
            }
        }
        .formStyle(.grouped)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ExternalDisplaySettingsView()
}
