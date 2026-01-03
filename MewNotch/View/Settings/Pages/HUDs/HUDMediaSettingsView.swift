//
//  HUDMediaSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDMediaSettingsView: View {
    
    @StateObject var mediaDefaults = HUDMediaDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows media playing app with animation",
                    icon: "music.note",
                    color: .pink
                ) {
                    Toggle("", isOn: $mediaDefaults.isEnabled)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Media")
    }
}

#Preview {
    HUDMediaSettingsView()
}
