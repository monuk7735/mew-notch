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
                    icon: "bolt.fill",
                    color: .green
                ) {
                    Toggle("", isOn: $powerDefaults.isEnabled)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Power")
    }
}

#Preview {
    HUDPowerSettingsView()
}
