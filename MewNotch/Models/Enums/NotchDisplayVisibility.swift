//
//  NotchDisplayVisibility.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//

import Foundation

enum NotchDisplayVisibility: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case AllDisplays
    case NotchedDisplayOnly
    
    case Custom
    
    var displayName: String {
        switch self {
        case .AllDisplays:
            return String(localized: "All Displays", comment: "Option to show notch on all connected displays")
        case .NotchedDisplayOnly:
            return String(localized: "Notched Displays Only", comment: "Option to show notch only on displays with a hardware notch")
        case .Custom:
            return String(localized: "Custom", comment: "Option to choose custom displays for showing notch")
        }
    }
}
