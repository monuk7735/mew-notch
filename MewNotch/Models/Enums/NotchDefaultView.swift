//
//  NotchDefaultView.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/10/26.
//

import Foundation

enum NotchDefaultView: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case home = "Home"
    case shelf = "Shelf"
    case lastUsed = "LastUsed"

    var displayName: String {
        switch self {
        case .home:
            String(localized: "Home", comment: "Option to show Home view when expanding the notch")
        case .shelf:
            String(localized: "Shelf", comment: "Option to show Shelf view when expanding the notch")
        case .lastUsed:
            String(localized: "Last Used", comment: "Option to retain the last used view when expanding the notch")
        }
    }

    var viewType: ExpandedNotchViewModel.NotchViewType? {
        switch self {
        case .home:
            .home
        case .shelf:
            .shelf
        case .lastUsed:
            nil
        }
    }
}
