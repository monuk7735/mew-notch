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
                            NavigationLink(destination: GeneraSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "gear", color: .gray)
                                    Text("General")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.General)
                            
                            NavigationLink(destination: NotchSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "macbook", color: .blue)
                                    Text("Notch")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.Notch)
                        }
                    )
                    
                    Section(
                         content: {
                            NavigationLink(destination: HUDBrightnessSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "sun.max.fill", color: .yellow)
                                    Text("Brightness")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.Brightness)
                            
                            NavigationLink(destination: HUDAudioSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "speaker.wave.3.fill", color: .blue)
                                    Text("Audio")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.Audio)
                            
                            NavigationLink(destination: HUDPowerSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "bolt.fill", color: .green)
                                    Text("Power")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.Power)
                            
                            NavigationLink(destination: HUDMediaSettingsView()) {
                                HStack(spacing: 12) {
                                    SettingsIcon(icon: "music.note", color: .pink)
                                    Text("Media")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .id(SettingsPages.Media)
                        },
                        header: {
                            Text("HUD")
                        }
                    )
                    
                    Section {
                        NavigationLink(destination: AboutAppView()) {
                            HStack(spacing: 12) {
                                SettingsIcon(icon: "info.circle", color: .gray)
                                Text("About")
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                        }
                        .id(SettingsPages.About)
                    }
                    
                }
            },
            detail: {
                GeneraSettingsView()
            }
        )
        .frame(minWidth: 600, minHeight: 450)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            window.styleMask.insert(.miniaturizable)
            window.styleMask.insert(.closable)
            
            NSApp.activate()
        }
    }
}

#Preview {
    MewSettingsView()
}
