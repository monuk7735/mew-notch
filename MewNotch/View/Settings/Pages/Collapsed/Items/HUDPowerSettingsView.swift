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
                    icon: MewNotch.Assets.icPower,
                    color: MewNotch.Colors.power
                ) {
                    Toggle("", isOn: $powerDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Show Time Remaining",
                    subtitle: "Displays estimated time remaining on battery",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $powerDefaults.showTimeRemaining)
                }
                .disabled(!powerDefaults.isEnabled)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Power")
    }
}

#Preview {
    HUDPowerSettingsView()
}
