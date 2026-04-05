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
                    icon: MewNotch.Assets.icMedia,
                    color: MewNotch.Colors.nowPlaying
                ) {
                    Toggle("", isOn: $mediaDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Show Title",
                    subtitle: "Shows new media name on change",
                    icon: MewNotch.Assets.icAlbumName,
                    color: MewNotch.Colors.albumName
                ) {
                    Toggle("", isOn: $mediaDefaults.showTitleChange)
                }
                .hide(when: !mediaDefaults.isEnabled)
                
                SettingsRow(
                    title: "Visible For",
                    subtitle: "Shows new media name for \(mediaDefaults.titleChangeTimeout.formatted()) seconds",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Slider(
                        value: $mediaDefaults.titleChangeTimeout,
                        in: 1...10,
                        step: 1.0
                    )
                }
                .animation(nil, value: mediaDefaults.titleChangeTimeout)
                .hide(when: !mediaDefaults.isEnabled || !mediaDefaults.showTitleChange)
            } header: {
                Text("General")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Media")
    }
}

#Preview {
    HUDMediaSettingsView()
}
