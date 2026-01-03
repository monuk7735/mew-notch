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
        self.refreshNSScreens()
        
        NotchDefaults.shared.objectWillChange
            .sink { [weak self] _ in
            }
            .store(in: &cancellables)
    }
    
    func refreshNSScreens() {
        Task { @MainActor in
            withAnimation {
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
