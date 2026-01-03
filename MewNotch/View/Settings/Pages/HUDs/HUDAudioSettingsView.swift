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
                    icon: "mic.fill",
                    color: .green
                ) {
                    Toggle("", isOn: $viewModel.inputDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Style",
                    icon: "paintbrush.fill",
                    color: .blue
                ) {
                    Picker("", selection: $viewModel.inputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.inputDefaults.isEnabled)
            } header: {
                Text("Input")
            } footer: {
                Text("Design to be used for HUD")
            }
            
            Section {
                SettingsRow(
                    title: "Enabled",
                    subtitle: "Shows volume changes",
                    icon: "speaker.wave.2.fill",
                    color: .green
                ) {
                    Toggle("", isOn: $viewModel.outputDefaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Style",
                    icon: "paintbrush.fill",
                    color: .blue
                ) {
                    Picker("", selection: $viewModel.outputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.outputDefaults.isEnabled)
                
                if viewModel.outputDefaults.isEnabled {
                    HStack(alignment: .top, spacing: 16) {
                        SettingsIcon(icon: "chart.bar.fill", color: .orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Step Size")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(viewModel.localVolumeStep))%")
                                    .font(.body)
                                    .monospacedDigit()
                                    .bold()
                            }
                            
                            Slider(
                                value: $viewModel.localVolumeStep,
                                in: 1...10,
                                step: 1
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
            } header: {
                Text("Output")
            } footer: {
                Text("Design to be used for HUD")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Audio")
    }
}

#Preview {
    HUDAudioSettingsView()
}
