//
//  AppDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

class AppDefaults: ObservableObject {
    
    private static var PREFIX: String = "App_"
    
    static let shared = AppDefaults()
    
    private init() {}
    
    @PrimitiveUserDefault(
        PREFIX + "StatusIconShown",
        defaultValue: true
    )
    var showMenuIcon: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "DisableSystemHUD",
        defaultValue: true
    )
    var disableSystemHUD: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
}
