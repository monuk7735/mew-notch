//
//  HUDEnums.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum HUDStyle: String, CaseIterable, Identifiable, Codable {
    var id: String {
        rawValue
    }

    case minimal = "Minimal"
    case progress = "Progress"

    var displayName: String {
        switch self {
        case .minimal:
            String(localized: "Minimal", comment: "Minimal style for system HUD display")
        case .progress:
            String(localized: "Progress", comment: "Progress bar style for system HUD display")
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = HUDStyle(rawValue: raw) ?? .minimal
    }
}
