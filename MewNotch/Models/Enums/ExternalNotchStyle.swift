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

    case simulatedNotch = "SimulatedNotch"
    case floatingIsland = "FloatingIsland"
    case hudOnly = "HUDOnly"

    var displayName: LocalizedStringKey {
        switch self {
        case .simulatedNotch:
            "Notch"
        case .floatingIsland:
            "Island"
        case .hudOnly:
            "HUD"
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .simulatedNotch:
            "Simulates a full Mac-style notch connected to the top bezel"
        case .floatingIsland:
            "Shows a persistent floating pill unattached to the top bezel"
        case .hudOnly:
            "Only shows a compact floating HUD when volume or brightness changes"
        }
    }
}
