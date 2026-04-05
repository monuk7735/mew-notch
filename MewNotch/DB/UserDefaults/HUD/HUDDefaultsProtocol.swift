//
//  HUDProtocol.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

protocol HUDDefaultsProtocol: ObservableObject {
    
    static var PREFIX: String { get }
    
    var isEnabled: Bool { get set }
    var style: HUDStyle { get set }
    var animateChanges: Bool { get }
}
