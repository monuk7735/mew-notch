//
//  LockScreenSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct LockScreenSettingsView: View {
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Show on Lock Screen",
                    subtitle: "Displays the notch on the lock screen",
                    icon: .lock,
                    color: AppColor.lock
                ) {
                    Toggle("", isOn: $notchDefaults.shownOnLockScreen)
                        .onChange(of: notchDefaults.shownOnLockScreen) { _, _ in
                            NotchManager.shared.refreshNotches(killAllWindows: true)
                        }
                }
            } header: {
                Text("General")
            }

            Section {
                SettingsRow(
                    title: "Audio Output",
                    subtitle: "Volume and output device changes",
                    icon: .audio,
                    color: AppColor.audio
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowAudioOutputHUD)
                }

                SettingsRow(
                    title: "Audio Input",
                    subtitle: "Microphone and input device changes",
                    icon: .microphone,
                    color: AppColor.audio
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowAudioInputHUD)
                }

                SettingsRow(
                    title: "Brightness",
                    subtitle: "Display brightness changes",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowBrightnessHUD)
                }

                SettingsRow(
                    title: "Power",
                    subtitle: "Battery level and charging status",
                    icon: .power,
                    color: AppColor.power
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowPowerHUD)
                }

                SettingsRow(
                    title: "Now Playing",
                    subtitle: "Media playback and track changes",
                    icon: .media,
                    color: AppColor.nowPlaying
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowMediaHUD)
                }

                SettingsRow(
                    title: "Lock Status Alerts",
                    subtitle: "Screen locked and unlocked notifications",
                    icon: .lock,
                    color: AppColor.lock
                ) {
                    Toggle("", isOn: $notchDefaults.lockScreenShowLockStatusHUD)
                }
            } header: {
                Text("HUD Updates")
            } footer: {
                Text("Choose which HUD indicators are allowed to display while the screen is locked.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .disabled(!notchDefaults.shownOnLockScreen)
        }
        .formStyle(.grouped)
        .navigationTitle("Lock Screen")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    LockScreenSettingsView()
}
