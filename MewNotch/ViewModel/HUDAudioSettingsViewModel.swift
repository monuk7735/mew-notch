//
//  HUDAudioSettingsViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI
import Combine

final class HUDAudioSettingsViewModel: ObservableObject {
    
    @ObservedObject var inputDefaults = HUDAudioInputDefaults.shared
    @ObservedObject var outputDefaults = HUDAudioOutputDefaults.shared
    
    @Published var localVolumeStep: Double
    
    private var debounceTask: Task<Void, Error>?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.localVolumeStep = HUDAudioOutputDefaults.shared.step
        
        $localVolumeStep
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
                self.outputDefaults.step = newValue
            }
        }
    }
}
