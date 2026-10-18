//
//  MewNotchApp.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import Sparkle
import SwiftUI

@main
struct MewNotchApp: App {
    @NSApplicationDelegateAdaptor(MewAppDelegate.self) var mewAppDelegate

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    @StateObject private var updaterViewModel: UpdaterViewModel = .shared

    @ObservedObject private var appDefaults = AppDefaults.shared

    @State private var isMenuShown: Bool = true

    init() {
        _isMenuShown = .init(
            initialValue: appDefaults.showMenuIcon
        )
    }

    var body: some Scene {
        MenuBarExtra(
            isInserted: $isMenuShown,
            content: {
                Text("MewNotch")

                NotchOptionsView()
            },
            label: {
                AppAsset.menuBarIcon
                    .renderingMode(.template)
            }
        )
        .onChange(
            of: appDefaults.showMenuIcon
        ) { oldVal, newVal in
            if oldVal != newVal {
                isMenuShown = newVal
            }
        }

        Settings {
            MewSettingsView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 800, height: 500)
        .defaultPosition(.center)
    }
}
