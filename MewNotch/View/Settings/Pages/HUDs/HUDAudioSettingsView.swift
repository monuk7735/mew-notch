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
            Section(
                content: {
                    Toggle(isOn: $viewModel.inputDefaults.isEnabled) {
                        VStack(alignment: .leading) {
                            Text("Enabled")
                            Text("Shows volume changes")
                                .font(.footnote)
                        }
                    }

                    Picker(
                        selection: $viewModel.inputDefaults.style,
                        content: {
                            ForEach(
                                HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                    ) {
                        Text("Style")
                    }
                    .disabled(!viewModel.inputDefaults.isEnabled)
                },
                header: {
                    Text("Input")
                },
                footer: {
                    Text("Design to be used for HUD")
                }
            )
            
            Section(
                content: {
                    Toggle(isOn: $viewModel.outputDefaults.isEnabled) {
                        VStack(alignment: .leading) {
                            Text("Enabled")
                            Text("Shows volume changes")
                                .font(.footnote)
                        }
                    }

                    Picker(
                        selection: $viewModel.outputDefaults.style,
                        content: {
                            ForEach(
                                HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }

                    ) {
                        Text("Style")
                    }
                    .disabled(!viewModel.outputDefaults.isEnabled)
                    
                    if viewModel.outputDefaults.isEnabled {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Step Size")
                                Spacer()
                                Text("\(Int(viewModel.localVolumeStep))%")
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
                },
                header: {
                    Text("Output")
                },
                footer: {
                    Text("Design to be used for HUD")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Audio")
    }
}

#Preview {
    HUDAudioSettingsView()
}
