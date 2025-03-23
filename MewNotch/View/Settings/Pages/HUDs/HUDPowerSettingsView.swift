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
            Section(
                content: {
                    Toggle(
                        isOn: $powerDefaults.isEnabled
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Enabled")
                        }
                    }
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Power")
    }
}

#Preview {
    HUDPowerSettingsView()
}
