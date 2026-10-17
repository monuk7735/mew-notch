//
//  NotchOptionsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 15/05/25.
//

import SwiftUI

struct NotchOptionsView: View {
    enum OptionsType {
        case contextMenu
        case menuBar
    }

    @Environment(\.openSettings) private var openSettings

    @StateObject var updaterViewModel: UpdaterViewModel = .shared
    @StateObject private var appDefaults = AppDefaults.shared

    var type: OptionsType = .contextMenu

    var body: some View {
        Button("Refresh Notch") {
            NotchManager.shared.refreshNotches(killAllWindows: true)
        }

        Button("Settings") {
            openSettings.callAsFunctionBringingToFront()
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
