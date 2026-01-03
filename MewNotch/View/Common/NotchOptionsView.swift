//
//  NotchOptionsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 15/05/25.
//

import SwiftUI

struct NotchOptionsView: View {
    
    enum OptionsType {
        case ContextMenu
        case MenuBar
    }
    
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var updaterViewModel: UpdaterViewModel
    
    @StateObject private var appDefaults = AppDefaults.shared
    
    var type: OptionsType = .ContextMenu
    
    var body: some View {
        Button("Fix Notch") {
            NotchManager.shared.refreshNotches()
        }
        
        if appDefaults.disableSystemHUD {
            Button("Fix System HUD") {
                OSDUIManager.shared.reset()
            }
        }
        
        Button("Settings") {
            openSettings()
        }
        .keyboardShortcut(
            ",",
            modifiers: .command
        )
        
        Button("Quit") {
            AppManager.shared.kill()
        }
        .keyboardShortcut("R", modifiers: .command)
        
        Divider()
        
        Button("Check for Updates...") {
            updaterViewModel.checkForUpdates()
        }
        .disabled(!updaterViewModel.canCheckForUpdates)
    }
}

#Preview {
    NotchOptionsView()
}
