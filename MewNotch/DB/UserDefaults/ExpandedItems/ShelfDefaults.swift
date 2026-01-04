//
//  ShelfDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 12/07/25.
//

import Foundation
import SwiftUI

class ShelfDefaults: ObservableObject {
    
    internal static var PREFIX: String = "Shelf_"
    
    static let shared = ShelfDefaults()
    
    private init() {}
    
    @CodableUserDefault(
        PREFIX + "FileGroups",
        defaultValue: []
    )
    var shelfFileGroups: [ShelfFileGroupModel] {
        didSet {
            self.objectWillChange.send()
        }
    }
}
