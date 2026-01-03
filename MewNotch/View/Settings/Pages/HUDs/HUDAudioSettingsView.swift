//
//  HUDAudioSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDAudioSettingsView: View {
    
    @StateObject var audioInputDefaults = HUDAudioInputDefaults.shared
    @StateObject var audioOutputDefaults = HUDAudioOutputDefaults.shared
    
    @State private var localVolumeStep: Double = HUDAudioOutputDefaults.shared.step
    @State private var debounceTask: Task<Void, Error>?
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle("Enabled", isOn: $audioInputDefaults.isEnabled)

                    Picker(
                        selection: $audioInputDefaults.style,
                        content: {
                            ForEach(
                                HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Style")

                            Text("Design to be used for HUD")
                                .font(.footnote)
                        }
                    }
                    .disabled(!audioInputDefaults.isEnabled)
                },
                header: {
                    Text("Input")
                }
            )
            
            Section(
                content: {
                    Toggle("Enabled", isOn: $audioOutputDefaults.isEnabled)

                    Picker(
                        selection: $audioOutputDefaults.style,
                        content: {
                            ForEach(
                                HUDStyle.allCases
                            ) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Style")

                            Text("Design to be used for HUD")
                                .font(.footnote)
                        }
                    }
                    .disabled(!audioOutputDefaults.isEnabled)
                    
                    if audioOutputDefaults.isEnabled {
                        HStack {
                            Text("Step Size: ")

                            Text("\(Int(localVolumeStep))%")
                                .monospacedDigit()
                                .bold()

                            Spacer()
                            
                            Slider(
                                value: $localVolumeStep,
                                in: 1...10,
                                step: 1
                            )
                            
                        }
                    }
                },
                header: {
                    Text("Output")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Audio")
        .onChange(of: localVolumeStep) { _, newValue in
            debounceTask?.cancel()
            debounceTask = Task {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                await MainActor.run {
                    audioOutputDefaults.step = newValue
                }
            }
        }
        .onAppear {
            localVolumeStep = audioOutputDefaults.step
        }
    }
}

#Preview {
    HUDAudioSettingsView()
}
