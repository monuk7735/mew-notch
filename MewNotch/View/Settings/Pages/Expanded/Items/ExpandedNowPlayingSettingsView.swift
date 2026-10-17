//
//  ExpandedNowPlayingSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct ExpandedNowPlayingSettingsView: View {
    @StateObject private var nowPlayingDefaults = NowPlayingDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Corner Radius",
                    icon: .cornerRadius,
                    color: AppColor.albumArt
                ) {
                    Slider(value: $nowPlayingDefaults.albumArtCornerRadius, in: 15 ... 50, step: 1)
                }

                SettingsRow(
                    title: "Show Artist",
                    icon: .artist,
                    color: AppColor.artist
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showArtist)
                }

                SettingsRow(
                    title: "Show Album",
                    icon: .albumName,
                    color: AppColor.albumName
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAlbum)
                }

                SettingsRow(
                    title: "Show App Icon",
                    icon: .appIcon,
                    color: AppColor.appIcon
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAppIcon)
                }

                SettingsRow(
                    title: "Enable Seekbar",
                    icon: .seekbar,
                    color: AppColor.seekbar
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.enableSeekbar)
                }
            } header: {
                Text("General Settings")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedNowPlayingSettingsView()
}
