//
//  NotchDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

class NotchDefaults: ObservableObject {
    
    private static var PREFIX: String = "Notch_"
    
    static let shared = NotchDefaults()
    
    private init() {}
    
    @CodableUserDefault(
        PREFIX + "NotchDisplayVisibility",
        defaultValue: NotchDisplayVisibility.NotchedDisplayOnly
    )
    var notchDisplayVisibility: NotchDisplayVisibility {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        PREFIX + "ShownOnDisplay",
        defaultValue: [:]
    )
    var shownOnDisplay: [String: Bool] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ShownOnLockScreen",
        defaultValue: true
    )
    var shownOnLockScreen: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        PREFIX + "HeightMode",
        defaultValue: NotchHeightMode.Match_Notch
    )
    var heightMode: NotchHeightMode {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ExpandOnHover",
        defaultValue: false
    )
    var expandOnHover: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ExpandedNotchShowDividers",
        defaultValue: true
    )
    var showDividers: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        PREFIX + "ExpandedNotchItems",
        defaultValue: [
            ExpandedNotchItem.Mirror
        ]
    )
    var expandedNotchItems: Set<ExpandedNotchItem> {
        didSet {
            self.objectWillChange.send()
        }
    }
}
