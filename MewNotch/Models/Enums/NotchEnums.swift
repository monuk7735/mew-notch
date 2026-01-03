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
        return self.rawValue.replacingOccurrences(of: "_", with: " ")
    }
}
    
