//
//  MewSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct MewSettingsView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    enum SettingsPages: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        
        case General
        case Notch
        
        case Brightness
        
        case Audio
//        case AudioOutput
//        case AudioInput
        
        case Media
        case Power
        
        case About
    }
    
    @StateObject var settingsViewModel: SettingsViewModel = .init()
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    @State var selectedPage: SettingsPages = .General
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(
                    selection: $selectedPage
                ) {
                    Section(
                        content: {
                            NavigationLink(
                                destination: {
                                    GeneraSettingsView(
                                        settingsViewModel: settingsViewModel
                                    )
                                }
                            ) {
                                Label(
                                    "General",
                                    systemImage: "gear"
                                )
                            }
                            .id(SettingsPages.General)
                            
                            
                            NavigationLink(
                                destination: {
                                    NotchSettingsView()
                                }
                            ) {
                                Label(
                                    title: {
                                        Text("Notch")
                                    },
                                    icon: {
                                        MewNotch.Assets.iconMenuBar
                                            .renderingMode(.template)
                                    }
                                )
                            }
                            .id(SettingsPages.Notch)
                        }
                    )
                    
                    Section(
                        content: {
                            NavigationLink(
                                destination: {
                                    HUDBrightnessSettingsView()
                                }
                            ) {
                                Label(
                                    "Brightness",
                                    systemImage: "rays"
                                )
                            }
                            .id(SettingsPages.Brightness)
                            
                            NavigationLink(
                                destination: {
                                    HUDAudioSettingsView()
                                }
                            ) {
                                Label(
                                    "Audio",
                                    systemImage: "waveform"
                                )
                            }
                            .id(SettingsPages.Audio)
                            
                            NavigationLink(
                                destination: {
                                    HUDPowerSettingsView()
                                }
                            ) {
                                Label(
                                    "Power",
                                    systemImage: "powerplug"
                                )
                            }
                            .id(SettingsPages.Power)
                            
                            NavigationLink(
                                destination: {
                                    HUDMediaSettingsView()
                                }
                            ) {
                                Label(
                                    "Media",
                                    systemImage: "music.note.list"
                                )
                            }
                            .id(SettingsPages.Media)
                        },
                        header: {
                            Text("HUD")
                        }
                    )
                    
                    Section {
                        NavigationLink(
                            destination: {
                                AboutAppView(
                                    settingsViewModel: settingsViewModel
                                )
                            }
                        ) {
                            Label(
                                "About",
                                systemImage: "info.circle"
                            )
                        }
                        .id(SettingsPages.About)
                    }
                    
                }
            },
            detail: {
                GeneraSettingsView(
                    settingsViewModel: settingsViewModel
                )
            }
        )
        .task {
            guard let window = NSApp.windows.first(
                where: {
                    $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window"
                }
            ) else {
                return
            }
            
            window.toolbarStyle = .unified
            window.styleMask.insert(.resizable)
            
            NSApp.activate()
        }
    }
}

#Preview {
    MewSettingsView()
}
