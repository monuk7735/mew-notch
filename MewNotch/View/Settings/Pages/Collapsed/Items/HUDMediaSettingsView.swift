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
                    icon: .media,
                    color: AppColor.nowPlaying
                ) {
                    Toggle("", isOn: ~$mediaDefaults.isEnabled)
                }
            } header: {
                Text("General")
            }

            Section {
                SettingsRow(
                    title: "Animated",
                    subtitle: "Animate value changes",
                    icon: .video,
                    color: AppColor.video
                ) {
                    Toggle("", isOn: ~$mediaDefaults.animateChanges)
                }
                .hide(when: !mediaDefaults.isEnabled)
            } header: {
                Text("Appearance")
            }

            Section {
                SettingsRow(
                    title: "Show title on change",
                    subtitle: "Shows new media name on change",
                    icon: .media,
                    color: AppColor.nowPlaying
                ) {
                    Toggle("", isOn: ~$mediaDefaults.showTitleChange)
                }
                .hide(when: !mediaDefaults.isEnabled)

                SettingsRow(
                    title: "Show new title for",
                    subtitle: mediaDefaults.titleChangeTimeout.localizedSecondsKey(),
                    icon: .timer,
                    color: AppColor.timer
                ) {
                    Slider(
                        value: $mediaDefaults.titleChangeTimeout,
                        in: 1 ... 10,
                        step: 1.0
                    )
                }
                .hide(when: !mediaDefaults.isEnabled || !mediaDefaults.showTitleChange)
            } header: {
                Text("Behavior")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Media")
    }
}

#Preview {
    HUDMediaSettingsView()
}
