//
//  NotchSettingsViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI
import Combine

final class NotchSettingsViewModel: ObservableObject {
    
    @Published var screens: [NSScreen] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.refreshNSScreens(animate: false)
    }
    
    func refreshNSScreens(animate: Bool = true) {
        Task { @MainActor in
            if animate {
                withAnimation {
                    self.screens = NSScreen.screens
                }
            } else {
                self.screens = NSScreen.screens
            }
        }
    }
    
    func refreshNotches() {
        NotchManager.shared.refreshNotches()
    }
    
    func refreshNotchesAndKillWindows() {
         NotchManager.shared.refreshNotches(killAllWindows: true)
    }
}
