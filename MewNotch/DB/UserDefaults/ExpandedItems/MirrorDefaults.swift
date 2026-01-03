//
//  MirrorDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

class MirrorDefaults: ObservableObject {
    
    static let shared = MirrorDefaults()
    
    private static var PREFIX: String = "Expanded_Mirror_"
    
    private init() {}
    
    @AppStorage(PREFIX + "mirrorCornerRadius") var cornerRadius: Double = 50.0 {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}
