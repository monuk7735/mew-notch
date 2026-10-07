//
//  NotchHeightMode.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum NotchHeightMode: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    
    case Match_Notch
    case Match_Menu_Bar
    case Manual
    
    var displayName: String {
        switch self {
        case .Match_Notch:
            return String(localized: "Match Notch", comment: "Option to set notch height matching hardware notch")
        case .Match_Menu_Bar:
            return String(localized: "Match Menu Bar", comment: "Option to set notch height matching system menu bar")
        case .Manual:
            return String(localized: "Manual", comment: "Option to set notch height manually")
        }
    }
}
    
