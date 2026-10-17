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
                    title: "BetterDisplay Brightness Control",
                    subtitle: "Allow BetterDisplay to handle brightness keys when it is running instead of MewNotch capturing them",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Toggle("", isOn: $notchDefaults.yieldBrightnessToBetterDisplay)
                }

                SettingsRow(
                    title: "BetterDisplay Status",
                    subtitle: "Detects whether BetterDisplay is actively running on this system",
                    icon: .statusIcon,
                    color: AppColor.general
                ) {
                    let isRunning = BetterDisplayManager.shared.isBetterDisplayRunning
                    HStack(spacing: 6) {
                        Circle()
                            .fill(isRunning ? Color.green : Color.secondary)
                            .frame(width: 8, height: 8)
                        Text(isRunning ? "Running" : "Not Detected")
                            .font(.subheadline)
                            .foregroundStyle(isRunning ? .primary : .secondary)
                    }
                }
            } header: {
                Text("BetterDisplay Integration")
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
