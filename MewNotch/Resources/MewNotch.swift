//
//  MewNotch.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

import Lottie

class MewNotch {
    
    class Assets {
        static let iconMenuBar = Image("MenuBarIcon")
        
        static let iconBrightness = Image("Brightness")
        static let iconSpeaker = Image("Speaker")
    }
    
    class Colors {
        
    }
    
    class Lotties {
        static let brightness = LottieAnimation.named("Brightness.json")
        static let speaker = LottieAnimation.named("Speaker.json")
        static let visualizer = LottieAnimation.named("Visualizer.json")
        static let lock = LottieAnimation.named("Lock.json")
    }
    
}
