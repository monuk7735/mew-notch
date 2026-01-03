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
                    icon: "sun.max.fill",
                    color: .yellow
                ) {
                    Toggle("", isOn: $viewModel.defaults.isEnabled)
                }
                
                SettingsRow(
                    title: "Style",
                    icon: "paintbrush.fill",
                    color: .blue
                ) {
                    Picker("", selection: $viewModel.defaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.defaults.isEnabled)
                
                SettingsRow(
                    title: "Show Auto Brightness Changes",
                    icon: "bolt.badge.automatic.fill",
                    color: .green
                ) {
                    Toggle("", isOn: $viewModel.defaults.showAutoBrightnessChanges)
                }
                
                if viewModel.defaults.isEnabled {
                    HStack(alignment: .top, spacing: 16) {
                        SettingsIcon(icon: "chart.bar.fill", color: .orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Step Size")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(viewModel.localStep * 100))%")
                                    .font(.body)
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
                    .padding(.vertical, 8)
                }
            } footer: {
               Text("Design to be used for HUD")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Brightness")
    }
}

#Preview {
    HUDBrightnessSettingsView()
}
