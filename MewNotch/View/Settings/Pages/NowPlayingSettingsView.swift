//
//  NowPlayingSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct NowPlayingSettingsView: View {
    
    @StateObject private var nowPlayingDefaults = NowPlayingDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Enabled",
                    icon: MewNotch.Assets.icNowPlaying,
                    color: MewNotch.Colors.nowPlaying
                ) {
                    Toggle("", isOn: Binding(
                        get: { notchDefaults.expandedNotchItems.contains(.NowPlaying) },
                        set: { isEnabled in
                            if isEnabled {
                                notchDefaults.expandedNotchItems.insert(.NowPlaying)
                            } else {
                                notchDefaults.expandedNotchItems.remove(.NowPlaying)
                            }
                        }
                    ))
                }
                
                if notchDefaults.expandedNotchItems.contains(.NowPlaying) {
                    SettingsRow(
                        title: "Corner Radius",
                        icon: MewNotch.Assets.icCornerRadius,
                        color: MewNotch.Colors.albumArt
                    ) {
                        Slider(value: $nowPlayingDefaults.albumArtCornerRadius, in: 15...50, step: 1)
                    }
                    
                    SettingsRow(
                        title: "Show Artist",
                        icon: MewNotch.Assets.icArtist,
                        color: MewNotch.Colors.artist
                    ) {
                        Toggle("", isOn: $nowPlayingDefaults.showArtist)
                    }
                    
                    SettingsRow(
                        title: "Show Album",
                        icon: MewNotch.Assets.icAlbumName,
                        color: MewNotch.Colors.albumName
                    ) {
                        Toggle("", isOn: $nowPlayingDefaults.showAlbum)
                    }
                    
                    SettingsRow(
                        title: "Show App Icon",
                        icon: MewNotch.Assets.icAppIcon,
                        color: MewNotch.Colors.appIcon
                    ) {
                        Toggle("", isOn: $nowPlayingDefaults.showAppIcon)
                    }
                }
            } header: {
                Text("General")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Now Playing")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NowPlayingSettingsView()
}
