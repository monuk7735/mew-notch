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
                    icon: MewNotch.Assets.icBrightnessFill,
                    color: MewNotch.Colors.brightness
                ) {
                    Toggle("", isOn: ~$viewModel.defaults.isEnabled)
                }
            } header: {
                Text("General")
            }
                
            Section {
                SettingsRow(
                    title: "Style",
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: ~$viewModel.defaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .hide(when: !viewModel.defaults.isEnabled)
                
                SettingsRow(
                    title: "Animated",
                    subtitle: "Animate value changes",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $viewModel.defaults.animateChanges)
                }
                .hide(when: !viewModel.defaults.isEnabled || viewModel.defaults.style != .Minimal)
            } header: {
                Text("Appearance")
            }
                
            Section {
                SettingsRow(
                    title: "Show Auto Brightness Changes",
                    icon: MewNotch.Assets.icBoltBadgeAutomatic,
                    color: MewNotch.Colors.autoBrightness
                ) {
                    Toggle("", isOn: ~$viewModel.defaults.showAutoBrightnessChanges)
                }
                .hide(when: !viewModel.defaults.isEnabled)
                
                SettingsRow(
                    title: "Step Size",
                    subtitle: "\(Int(viewModel.localStep * 100))%",
                    icon: MewNotch.Assets.icChartBar,
                    color: MewNotch.Colors.stepSize
                ) {
                    Slider(
                        value: $viewModel.localStep,
                        in: 0.01...0.10,
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
