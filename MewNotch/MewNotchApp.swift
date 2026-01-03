//
//  MewNotchApp.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI
import SwiftData
import Sparkle

@main
struct MewNotchApp: App {
    
    @NSApplicationDelegateAdaptor(MewAppDelegate.self) var mewAppDelegate
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings
    
    private let updaterViewModel: UpdaterViewModel
    
    @ObservedObject private var appDefaults = AppDefaults.shared
    
    @State private var isMenuShown: Bool = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()
    
    init() {
        let updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        self.updaterViewModel = UpdaterViewModel(updaterController: updaterController)
        
        self._isMenuShown = .init(
            initialValue: self.appDefaults.showMenuIcon
        )
    }

    var body: some Scene {
        MenuBarExtra(
            isInserted: $isMenuShown,
            content: {
                Text("MewNotch")
                
                NotchOptionsView()
                    .environmentObject(updaterViewModel)
            }
        ) {
            MewNotch.Assets.iconMenuBar
                .renderingMode(.template)
        }
        .onChange(
            of: appDefaults.showMenuIcon
        ) { oldVal, newVal in
            if oldVal != newVal {
                isMenuShown = newVal
            }
        }
        
        Settings {
            MewSettingsView()
                .modelContainer(sharedModelContainer)
        }
    }
}
