//
//  HUDEnums.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum HUDStyle: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    
    case Minimal
    case Progress
    case Notched
    
    var displayName: String {
        switch self {
        case .Minimal:
            return String(localized: "Minimal", comment: "Minimal style for system HUD display")
        case .Progress:
            return String(localized: "Progress", comment: "Progress bar style for system HUD display")
        case .Notched:
            return String(localized: "Notched", comment: "Notched style integrated into notch for system HUD display")
        }
    }
}
