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
            Section(
                content: {
                    Toggle(isOn: $viewModel.defaults.isEnabled) {
                        VStack(alignment: .leading) {
                            Text("Enabled")
                            Text("Shows brightness changes")
                                .font(.footnote)
                        }
                    }

                    Picker(
                        selection: $viewModel.defaults.style,
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
                    .disabled(!viewModel.defaults.isEnabled)
                    
                    Toggle(
                        "Show Auto Brightness Changes",
                        isOn: $viewModel.defaults.showAutoBrightnessChanges
                    )
                    
                    if viewModel.defaults.isEnabled {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Step Size")
                                Spacer()
                                Text("\(Int(viewModel.localStep * 100))%")
                                    .monospacedDigit()
                                    .bold()
                            }
                            
                            Slider(
                                value: $viewModel.localStep,
                                in: 0.01...0.10,
                                step: 0.01
                            )
                        }
                    }
                },
                footer: {
                    Text("Design to be used for HUD")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Brightness")
    }
}

#Preview {
    HUDBrightnessSettingsView()
}
