//
//  HUDBrightnessDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class HUDBrightnessDefaults: HUDDefaultsProtocol {
    
    internal static var PREFIX: String = "HUD_Brightness_"
    
    static let shared = HUDBrightnessDefaults()
    
    private init() {}
    
    @PrimitiveUserDefault(
        PREFIX + "Enabled",
        defaultValue: true
    )
    var isEnabled: Bool {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @CodableUserDefault(
        PREFIX + "Style",
        defaultValue: HUDStyle.Minimal
    )
    var style: HUDStyle {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ShowAutoBrightnessChanges",
        defaultValue: false
    )
    var showAutoBrightnessChanges: Bool {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "Step",
        defaultValue: 0.05
    )
    var step: Double {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}
