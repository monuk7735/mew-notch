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
                        title: "Show Album Art",
                        icon: MewNotch.Assets.icAlbumArt,
                        color: MewNotch.Colors.albumArt
                    ) {
                        Toggle("", isOn: $nowPlayingDefaults.showAlbumArt)
                    }
                    
                    SettingsRow(
                        title: "Show Artist",
                        icon: MewNotch.Assets.icArtist,
                        color: MewNotch.Colors.artist
                    ) {
                        Toggle("", isOn: $nowPlayingDefaults.showArtist)
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
