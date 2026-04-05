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
    var isEnabled: Bool
    
    @CodableUserDefault(
        PREFIX + "Style",
        defaultValue: HUDStyle.Minimal
    )
    var style: HUDStyle
    
    @CodableUserDefault(
        PREFIX + "AnimateChanges",
        defaultValue: true
    )
    var animateChanges: Bool
    
    @PrimitiveUserDefault(
        PREFIX + "ShowAutoBrightnessChanges",
        defaultValue: false
    )
    var showAutoBrightnessChanges: Bool
    
    @PrimitiveUserDefault(
        PREFIX + "Step",
        defaultValue: 0.05
    )
    var step: Double
}
