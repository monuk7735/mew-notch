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
        
        case ExpandedItems
        case CollapsedItems
        
        case About
    }

    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    @State var selectedPage: SettingsPages = .General
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(
                selection: $selectedPage
            ) {
                Section(
                    content: {
                        NavigationLink(destination: GeneraSettingsView()) {
                            SettingsSidebarRow(title: "General", icon: MewNotch.Assets.icGeneral, color: MewNotch.Colors.general)
                        }
                        .id(SettingsPages.General)
                        
                        NavigationLink(destination: NotchSettingsView()) {
                            SettingsSidebarRow(title: "Notch", icon: MewNotch.Assets.icNotch, color: MewNotch.Colors.notch)
                        }
                        .id(SettingsPages.Notch)
                    }
                        

                )
                
                Section(
                    content: {
                        NavigationLink(destination: CollapsedItemsSettingsView()) {
                            SettingsSidebarRow(title: "Collapsed", icon: MewNotch.Assets.icHud, color: MewNotch.Colors.hud)
                        }
                        .id(SettingsPages.CollapsedItems)
                        
                        NavigationLink(destination: ExpandedItemsSettingsView()) {
                            SettingsSidebarRow(title: "Expanded", icon: MewNotch.Assets.icMedia, color: MewNotch.Colors.nowPlaying)
                        }
                        .id(SettingsPages.ExpandedItems)
                    },
                    header: {
                        Text("Notch Items")
                    }
                )
                
                Section {
                    NavigationLink(destination: AboutAppView()) {
                        SettingsSidebarRow(title: "About", icon: MewNotch.Assets.icAbout, color: MewNotch.Colors.about)
                    }
                    .id(SettingsPages.About)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 180, max: 200)
            .listStyle(.sidebar)
        } detail: {
            Group {
                GeneraSettingsView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 800, minHeight: 500)
        .task {
            DispatchQueue.main.async {
                guard let window = NSApp.windows.first(
                    where: {
                        $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" ||
                        ($0.styleMask.contains(.titled) && $0.styleMask.contains(.closable))
                    }
                ) else {
                    return
                }
                
                window.toolbarStyle = .unified
                window.styleMask.insert(.resizable)
                window.styleMask.insert(.miniaturizable)
                window.styleMask.insert(.closable)
                
                window.minSize = NSSize(width: 800, height: 500)
                window.setContentSize(NSSize(width: 800, height: 500))
                window.center()
                
                NSApp.activate()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
            guard let window = notification.object as? NSWindow,
                  window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" ||
                  (window.styleMask.contains(.titled) && window.styleMask.contains(.closable)) else {
                return
            }
            if window.frame.width > 820 {
                window.minSize = NSSize(width: 800, height: 500)
                window.setContentSize(NSSize(width: 800, height: 500))
                window.center()
            }
        }
    }
}

#Preview {
    MewSettingsView()
}
