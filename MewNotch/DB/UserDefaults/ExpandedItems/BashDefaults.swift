//
//  BashDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/02/2026.
//

import SwiftUI

class BashDefaults: ObservableObject {
    
    static let shared = BashDefaults()
    
    private static var PREFIX: String = "Bash_"
    
    private init() {}
    
    @CodableUserDefault(
        PREFIX + "Command",
        defaultValue: "echo \"Hello World\""
    )
    var command: String {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "RefreshInterval",
        defaultValue: 5.0
    )
    var refreshInterval: Double {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "WidthMultiplier",
        defaultValue: 1.5
    )
    var widthMultiplier: Double {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "AutoRefresh",
        defaultValue: true
    )
    var autoRefresh: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ShowCommand",
        defaultValue: true
    )
    var showCommand: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
}
