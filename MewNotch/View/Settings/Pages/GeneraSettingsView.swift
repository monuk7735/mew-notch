//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct GeneraSettingsView: View {
    
    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var settingsViewModel: SettingsViewModel = .init()
    
    var body: some View {
        Form {
            Section(
                content: {
                    Toggle(
                        isOn: $appDefaults.showMenuIcon
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Status Icon")
                            
                            Text("Shown in Menu Bar for easy access")
                                .font(.footnote)
                        }
                    }
                },
                header: {
                    Text("App")
                }
            )
            
//            Section(
//                content: {
//                    Toggle(
//                        isOn: $defaultsManager.hudEnabled
//                    ) {
//                        VStack(
//                            alignment: .leading
//                        ) {
//                            Text("Enabled")
//                            
//                            Text("Show Volume and Brightness changes on Notch and turn off system HUD")
//                                .font(.footnote)
//                        }
//                    }
//                    
//                    Picker(
//                        selection: $defaultsManager.hudStyle,
//                        content: {
//                            ForEach(
//                                MewDefaultsManager.HUDStyle.allCases
//                            ) { style in
//                                Text(style.rawValue.capitalized)
//                                    .tag(style)
//                            }
//                        }
//                    ) {
//                        VStack(
//                            alignment: .leading
//                        ) {
//                            Text("Style")
//                            
//                            Text("Design to be used for HUD")
//                                .font(.footnote)
//                        }
//                    }
//                    .disabled(!defaultsManager.hudEnabled)
//                },
//                header: {
//                    Text("HUD")
//                }
//            )
        }
        .formStyle(.grouped)
        .navigationTitle("General")
    }
}

#Preview {
    GeneraSettingsView()
}
