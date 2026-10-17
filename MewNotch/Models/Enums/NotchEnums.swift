//
//  NotchEnums.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum NotchHeightMode: String, CaseIterable, Identifiable, Codable {
    var id: String {
        rawValue
    }

    case matchNotch = "Match_Notch"
    case matchMenuBar = "Match_Menu_Bar"
    case manual = "Manual"

    var displayName: String {
        switch self {
        case .matchNotch:
            String(localized: "Match Notch", comment: "Option to set notch height matching hardware notch")
        case .matchMenuBar:
            String(localized: "Match Menu Bar", comment: "Option to set notch height matching system menu bar")
        case .manual:
            String(localized: "Manual", comment: "Option to set notch height manually")
        }
    }
}
