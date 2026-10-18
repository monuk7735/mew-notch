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
                Section {
                    SettingsSidebarRow(title: "General", icon: .general, color: AppColor.general)
                        .tag(SettingsPages.general)

                    SettingsSidebarRow(title: "Notch", icon: .notch, color: AppColor.notch)
                        .tag(SettingsPages.notch)

                    SettingsSidebarRow(title: "Lock Screen", icon: .lock, color: AppColor.lock)
                        .tag(SettingsPages.lockScreen)

                    SettingsSidebarRow(title: "External Display", icon: .display, color: AppColor.externalDisplay)
                        .tag(SettingsPages.externalDisplay)
                }

                Section {
                    SettingsSidebarRow(title: "Collapsed", icon: .hud, color: AppColor.hud)
                        .tag(SettingsPages.collapsedItems)

                    SettingsSidebarRow(title: "Expanded", icon: .media, color: AppColor.nowPlaying)
                        .tag(SettingsPages.expandedItems)
                } header: {
                    Text("Notch Items")
                }

                Section {
                    SettingsSidebarRow(title: "About", icon: .about, color: AppColor.about)
                        .tag(SettingsPages.about)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 190, max: 220)
            .listStyle(.sidebar)
        } detail: {
            detailView(for: selectedPage)
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

    @ViewBuilder
    private func detailView(for page: SettingsPages) -> some View {
        switch page {
        case .general:
            GeneraSettingsView()
        case .notch:
            NotchSettingsView()
        case .lockScreen:
            LockScreenSettingsView()
        case .externalDisplay:
            ExternalDisplaySettingsView()
        case .collapsedItems:
            CollapsedItemsSettingsView()
        case .expandedItems:
            ExpandedItemsSettingsView()
        case .about:
            AboutAppView()
        }
    }
}

#Preview {
    MewSettingsView()
}
