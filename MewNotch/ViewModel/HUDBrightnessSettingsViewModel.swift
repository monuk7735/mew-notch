//
//  HUDBrightnessSettingsViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI
import Combine

final class HUDBrightnessSettingsViewModel: ObservableObject {
    
    @ObservedObject var defaults = HUDBrightnessDefaults.shared
    
    @Published var localStep: Double
    
    private var debounceTask: Task<Void, Error>?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.localStep = HUDBrightnessDefaults.shared.step
        
        $localStep
            .dropFirst()
            .sink { [weak self] newValue in
                self?.debounce(newValue: newValue)
            }
            .store(in: &cancellables)
    }
    
    private func debounce(newValue: Double) {
        debounceTask?.cancel()
        debounceTask = Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                self.defaults.step = newValue
            }
        }
    }
}
