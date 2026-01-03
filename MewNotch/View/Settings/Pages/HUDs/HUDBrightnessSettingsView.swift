//
//  HUDBrightnessSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDBrightnessSettingsView: View {
    
    @StateObject var brightnessDefaults = HUDBrightnessDefaults.shared
    
    @State private var localStep: Double = HUDBrightnessDefaults.shared.step
    @State private var debounceTask: Task<Void, Error>?
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle(
                        "Enabled",
                        isOn: $brightnessDefaults.isEnabled
                    )

                    Picker(
                        selection: $brightnessDefaults.style,
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
                    .disabled(!brightnessDefaults.isEnabled)
                    
                    Toggle(
                        "Show Auto Brightness Changes",
                        isOn: $brightnessDefaults.showAutoBrightnessChanges
                    )
                    
                    if brightnessDefaults.isEnabled {
                        Slider(
                            value: $localStep,
                            in: 0.01...0.10,
                            step: 0.01,
                            label: {
                                HStack {
                                    Text("Step Size")
                                    
                                    Text("\(Int(localStep * 100))%")
                                        .monospacedDigit()
                                        .bold()
                                }
                            }
                        )
                    }
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Brightness")
        .onChange(of: localStep) { _, newValue in
            debounceTask?.cancel()
            debounceTask = Task {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                await MainActor.run {
                    brightnessDefaults.step = newValue
                }
            }
        }
        .onAppear {
            localStep = brightnessDefaults.step
        }
    }
}

#Preview {
    HUDBrightnessSettingsView()
}
