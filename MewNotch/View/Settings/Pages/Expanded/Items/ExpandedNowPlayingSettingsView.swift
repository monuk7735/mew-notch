//
//  NowPlayingSettingsView.swift
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
            } header: {
                Text("General Settings")
            }
            
            Section {
                HStack {
                    Spacer()
                    Toggle(notchDefaults.expandedNotchItems.contains(.NowPlaying) ? "Enabled" : "Disabled", isOn: Binding(
                        get: { notchDefaults.expandedNotchItems.contains(.NowPlaying) },
                        set: { _ in toggleNowPlaying() }
                    ))
                    .toggleStyle(.switch)
                    .controlSize(.large)
                    Spacer()
                }
            }
        }
        .formStyle(.grouped)
    }
    
    private func toggleNowPlaying() {
        if notchDefaults.expandedNotchItems.contains(.NowPlaying) {
            notchDefaults.expandedNotchItems.removeAll { $0 == .NowPlaying }
        } else {
            notchDefaults.expandedNotchItems.append(.NowPlaying)
            notchDefaults.expandedNotchItems.sort { a, b in
                let indexA = notchDefaults.expandedItemsOrder.firstIndex(of: a) ?? 0
                let indexB = notchDefaults.expandedItemsOrder.firstIndex(of: b) ?? 0
                return indexA < indexB
            }
        }
    }
}

#Preview {
    ExpandedNowPlayingSettingsView()
}
