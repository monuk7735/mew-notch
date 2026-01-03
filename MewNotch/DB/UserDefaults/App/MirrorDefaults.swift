//
//  MirrorDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import Foundation
import Combine
import SwiftUI

class MirrorDefaults: ObservableObject {
    
    static let shared = MirrorDefaults()
    
    @AppStorage("mirrorCornerRadius") var cornerRadius: Double = 50.0
    
    // You can add more customization here like border width, color, etc.
}
