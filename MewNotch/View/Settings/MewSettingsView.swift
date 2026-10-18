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
        var id: String {
            rawValue
        }

        case general = "General"
        case notch = "Notch"
        case lockScreen = "LockScreen"
        case externalDisplay = "ExternalDisplay"

        case expandedItems = "ExpandedItems"
        case collapsedItems = "CollapsedItems"

        case about = "About"
    }

    @StateObject var defaultsManager = MewDefaultsManager.shared

    @State var selectedPage: SettingsPages = .general

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(
                selection: $selectedPage
            ) {
                Section(
                    content: {
                        NavigationLink(destination: GeneraSettingsView()) {
                            SettingsSidebarRow(title: "General", icon: .general, color: AppColor.general)
                        }
                        .id(SettingsPages.general)

                        NavigationLink(destination: NotchSettingsView()) {
                            SettingsSidebarRow(title: "Notch", icon: .notch, color: AppColor.notch)
                        }
                        .id(SettingsPages.notch)

                        NavigationLink(destination: LockScreenSettingsView()) {
                            SettingsSidebarRow(title: "Lock Screen", icon: .lock, color: AppColor.lock)
                        }
                        .id(SettingsPages.lockScreen)

                        NavigationLink(destination: ExternalDisplaySettingsView()) {
                            SettingsSidebarRow(title: "External Display", icon: .display, color: AppColor.externalDisplay)
                        }
                        .id(SettingsPages.externalDisplay)
                    }
                )

                Section(
                    content: {
                        NavigationLink(destination: CollapsedItemsSettingsView()) {
                            SettingsSidebarRow(title: "Collapsed", icon: .hud, color: AppColor.hud)
                        }
                        .id(SettingsPages.collapsedItems)

                        NavigationLink(destination: ExpandedItemsSettingsView()) {
                            SettingsSidebarRow(title: "Expanded", icon: .media, color: AppColor.nowPlaying)
                        }
                        .id(SettingsPages.expandedItems)
                    },
                    header: {
                        Text("Notch Items")
                    }
                )

                Section {
                    NavigationLink(destination: AboutAppView()) {
                        SettingsSidebarRow(title: "About", icon: .about, color: AppColor.about)
                    }
                    .id(SettingsPages.about)
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
            }
        }
    }
}

#Preview {
    MewSettingsView()
}
