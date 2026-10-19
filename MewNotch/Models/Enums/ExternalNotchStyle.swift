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

    case hudOnly = "HUDOnly"
    case floatingIsland = "FloatingIsland"
    case simulatedNotch = "SimulatedNotch"

    var displayName: LocalizedStringKey {
        switch self {
        case .hudOnly:
            "HUD Only"
        case .floatingIsland:
            "Floating Island"
        case .simulatedNotch:
            "Simulated Notch"
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .hudOnly:
            "Only shows a compact floating HUD when volume or brightness changes"
        case .floatingIsland:
            "Shows a persistent floating pill unattached to the top bezel"
        case .simulatedNotch:
            "Simulates a full Mac-style notch connected to the top bezel"
        }
    }
}
