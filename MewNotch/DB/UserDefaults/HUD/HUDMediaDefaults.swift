//
//  HUDMediaDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class HUDMediaDefaults: HUDDefaultsProtocol {
    
    internal static var PREFIX: String = "HUD_Media_"
    
    static let shared = HUDMediaDefaults()
    
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
    
    @PrimitiveUserDefault(
        PREFIX + "ShowTitleOnChange",
        defaultValue: true
    )
    var showTitleChange: Bool
    
    @PrimitiveUserDefault(
        PREFIX + "AnimateChanges",
        defaultValue: true
    )
    var animateChanges: Bool
    
    @PrimitiveUserDefault(
        PREFIX + "ShowTitleOnChangeTimeout",
        defaultValue: 3.0
    )
    var titleChangeTimeout: Double
}
