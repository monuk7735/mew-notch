//
//  UpdaterViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/26.
//

import Sparkle
import SwiftUI

final class UpdaterViewModel: NSObject, ObservableObject, SPUStandardUserDriverDelegate {
    static let shared = UpdaterViewModel()

    private var updaterController: SPUStandardUpdaterController!

    override init() {
        super.init()
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: self
        )
    }

    var supportsGentleScheduledUpdateReminders: Bool {
        true
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }

    var canCheckForUpdates: Bool {
        updaterController.updater.canCheckForUpdates
    }

    var currentVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return "\(version)"
    }
}
