//
//  HUDAudioInputDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class HUDAudioInputDefaults: HUDDefaultsProtocol {
    
    internal static var PREFIX: String = "HUD_Audio_Input_"
    
    static let shared = HUDAudioInputDefaults()
    
    private init() {}
    
    /// Off by default. The microphone level is normally driven by whatever
    /// meeting app is running (automatic gain control), not by the user, and
    /// showing it turns every background adjustment into a HUD update. The
    /// system HUD only reports speaker volume for the same reason. Users who
    /// want to watch the input level can still turn this on in Settings.
    @PrimitiveUserDefault(
        PREFIX + "Enabled",
        defaultValue: false
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
}

