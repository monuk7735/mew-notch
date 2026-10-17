//
//  HUDPowerSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDPowerSettingsView: View {
    @StateObject var powerDefaults = HUDPowerDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows power state when plugged in/out",
                    icon: .power,
                    color: AppColor.power
                ) {
                    Toggle("", isOn: ~$powerDefaults.isEnabled)
                }
            } header: {
                Text("General")
            }

            Section {
                SettingsRow(
                    title: "Show Time Remaining",
                    subtitle: "Displays estimated time remaining on battery",
                    icon: .timer,
                    color: AppColor.timer
                ) {
                    Toggle("", isOn: $powerDefaults.showTimeRemaining)
                }
                .hide(when: !powerDefaults.isEnabled)
            } header: {
                Text("Details")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Power")
    }
}

#Preview {
    HUDPowerSettingsView()
}
