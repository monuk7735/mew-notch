//
//  HUDBrightnessSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDBrightnessSettingsView: View {
    @StateObject private var viewModel = HUDBrightnessSettingsViewModel()

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows brightness changes",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Toggle("", isOn: ~$viewModel.defaults.isEnabled)
                }
            } header: {
                Text("General")
            }

            Section {
                SettingsRow(
                    title: "Style",
                    icon: .paintbrush,
                    color: AppColor.style
                ) {
                    Picker("", selection: ~$viewModel.defaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .hide(when: !viewModel.defaults.isEnabled)

                SettingsRow(
                    title: "Animated",
                    subtitle: "Animate value changes",
                    icon: .video,
                    color: AppColor.video
                ) {
                    Toggle("", isOn: $viewModel.defaults.animateChanges)
                }
                .hide(when: !viewModel.defaults.isEnabled || viewModel.defaults.style != .minimal)
            } header: {
                Text("Appearance")
            }

            Section {
                SettingsRow(
                    title: "Show Auto Brightness Changes",
                    icon: .boltBadgeAutomatic,
                    color: AppColor.autoBrightness
                ) {
                    Toggle("", isOn: ~$viewModel.defaults.showAutoBrightnessChanges)
                }
                .hide(when: !viewModel.defaults.isEnabled)

                SettingsRow(
                    title: "Step Size",
                    subtitle: viewModel.localStep.localizedPercentageKey(),
                    icon: .chartBar,
                    color: AppColor.stepSize
                ) {
                    Slider(
                        value: $viewModel.localStep,
                        in: 0.01 ... 0.10,
                        step: 0.01
                    )
                }
                .hide(when: !viewModel.defaults.isEnabled)
            } header: {
                Text("Details")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Brightness")
    }
}

#Preview {
    HUDBrightnessSettingsView()
}
