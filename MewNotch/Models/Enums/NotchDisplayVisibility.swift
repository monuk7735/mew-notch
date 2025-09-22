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
            return "All Displays"
        case .NotchedDisplayOnly:
            return "Notched Displays Only"
        case .Custom:
            return "Custom"
        }
    }
}
