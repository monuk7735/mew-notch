//
//  ExternalNotchStyle.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/10/26.
//

import SwiftUI

enum ExternalNotchStyle: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case notch = "Notch"
    case island = "Island"
    case hud = "HUD"

    var displayName: LocalizedStringKey {
        switch self {
        case .notch:
            "Notch"
        case .island:
            "Island"
        case .hud:
            "HUD"
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .notch:
            "Simulates a full Mac-style notch connected to the top bezel"
        case .island:
            "Shows a persistent floating pill unattached to the top bezel"
        case .hud:
            "Only shows a compact floating HUD when volume or brightness changes"
        }
    }
}
