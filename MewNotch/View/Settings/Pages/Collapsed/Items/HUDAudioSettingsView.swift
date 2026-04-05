//
//  HUDAudioSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDAudioSettingsView: View {
    
    @StateObject private var viewModel = HUDAudioSettingsViewModel()
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows volume changes",
                    icon: MewNotch.Assets.icSpeakerWave2,
                    color: MewNotch.Colors.output
                ) {
                    Toggle("", isOn: |$viewModel.outputDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Style",
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: $viewModel.outputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .hide(when: !viewModel.outputDefaults.isEnabled)
                
                SettingsRow(
                    title: "Animated",
                    subtitle: "Animate value changes",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $viewModel.outputDefaults.animateChanges)
                }
                .hide(when: !viewModel.outputDefaults.isEnabled || viewModel.outputDefaults.style != .Minimal)
                
                SettingsRow(
                    title: "Step Size",
                    subtitle: "\(Int(viewModel.localVolumeStep))%",
                    icon: MewNotch.Assets.icChartBar,
                    color: MewNotch.Colors.stepSize
                ) {
                    Slider(
                        value: $viewModel.localVolumeStep,
                        in: 1...10,
                        step: 1
                    )
                }
                .hide(when: !viewModel.outputDefaults.isEnabled)
            } header: {
                Text("Output")
            }
            
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows volume changes",
                    icon: MewNotch.Assets.icMicrophone,
                    color: MewNotch.Colors.input
                ) {
                    Toggle("", isOn: |$viewModel.inputDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Style",
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: $viewModel.inputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .hide(when: !viewModel.inputDefaults.isEnabled)
                
                SettingsRow(
                    title: "Animated",
                    subtitle: "Animate value changes",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $viewModel.inputDefaults.animateChanges)
                }
                .hide(when: !viewModel.inputDefaults.isEnabled || viewModel.inputDefaults.style != .Minimal)
            } header: {
                Text("Input")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Audio")
    }
}

#Preview {
    HUDAudioSettingsView()
}
