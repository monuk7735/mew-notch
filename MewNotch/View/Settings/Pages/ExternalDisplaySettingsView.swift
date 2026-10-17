//
//  ExternalDisplaySettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct ExternalDisplaySettingsView: View {
    @StateObject var notchDefaults = NotchDefaults.shared
    @ObservedObject var betterDisplayManager = BetterDisplayManager.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Brightness Control",
                    subtitle: "Let BetterDisplay handle brightness keys",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Toggle("", isOn: $notchDefaults.yieldBrightnessToBetterDisplay)
                }

                SettingsRow(
                    title: "Status",
                    subtitle: "Detects running application",
                    icon: .statusIcon,
                    color: AppColor.general
                ) {
                    let isRunning = betterDisplayManager.isBetterDisplayRunning
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
                Text("BetterDisplay")
            }

            Section {
                SettingsRow(
                    title: "Lock Screen Alerts",
                    subtitle: "Show lock status on all monitors",
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
        .onAppear {
            betterDisplayManager.updateRunningStatus()
        }
    }
}

#Preview {
    ExternalDisplaySettingsView()
}
