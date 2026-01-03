//
//  UpdaterViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/26.
//

import SwiftUI
import Sparkle

final class UpdaterViewModel: ObservableObject {
    
    private let updaterController: SPUStandardUpdaterController
    
    init(updaterController: SPUStandardUpdaterController) {
        self.updaterController = updaterController
    }
    
    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }
    
    var canCheckForUpdates: Bool {
        updaterController.updater.canCheckForUpdates
    }
}
