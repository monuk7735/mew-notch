//
//  NotchSettingsViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import Combine
import SwiftUI

final class NotchSettingsViewModel: ObservableObject {
    @Published var screens: [NSScreen] = NSScreen.screens

    private var cancellables = Set<AnyCancellable>()

    init() {
        addListenerForScreenUpdates()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func addListenerForScreenUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshScreens),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }

    @objc
    func refreshScreens() {
        DispatchQueue.main.async {
            self.screens = NSScreen.screens
        }
    }

    func refreshNotches() {
        NotchManager.shared.refreshNotches()
    }

    func refreshNotchesAndKillWindows() {
        NotchManager.shared.refreshNotches(killAllWindows: true)
    }
}
