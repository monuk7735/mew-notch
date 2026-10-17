//
//  NotchDisplayVisibility.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//

import Foundation

enum NotchDisplayVisibility: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case allDisplays = "AllDisplays"
    case notchedDisplayOnly = "NotchedDisplayOnly"
    case custom = "Custom"

    var displayName: String {
        switch self {
        case .allDisplays:
            String(localized: "All Displays", comment: "Option to show notch on all connected displays")
        case .notchedDisplayOnly:
            String(localized: "Notched Displays Only", comment: "Option to show notch only on displays with a hardware notch")
        case .custom:
            String(localized: "Custom", comment: "Option to choose custom displays for showing notch")
        }
    }
}
