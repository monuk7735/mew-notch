//
//  NotchSpaceManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

class NotchSpaceManager {
    
    static let shared = NotchSpaceManager()
    
    let notchSpace: CGSSpace
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    private init() {
        notchSpace = CGSSpace(level: 2147483647) // Max level
    }
}

public final class CGSSpace {
    
    private let identifier: CGSSpaceID
    private let createdByInit: Bool

    public var windows: Set<NSWindow> = [] {
        didSet {
            let remove = oldValue.subtracting(
                self.windows
            )
            
            let add = self.windows.subtracting(
                oldValue
            )
            
            CGSRemoveWindowsFromSpaces(
                _CGSDefaultConnection(),
                remove.map { $0.windowNumber
                } as NSArray,
                [self.identifier]
            )
            
            CGSAddWindowsToSpaces(
                _CGSDefaultConnection(),
                add.map { $0.windowNumber
                } as NSArray,
                [self.identifier]
            )
        }
    }

    /// Initialized `CGSSpace`s *MUST* be de-initialized upon app exit!
    public init(
        level: Int = 0
    ) {
        let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
        self.identifier = CGSSpaceCreate(
            _CGSDefaultConnection(),
            flag,
            nil
        )
        
        CGSSpaceSetAbsoluteLevel(
            _CGSDefaultConnection(),
            self.identifier,
            level
        )
        
        CGSShowSpaces(
            _CGSDefaultConnection(),
            [self.identifier]
        )
        
        self.createdByInit = true // Mark as created by the first init
    }

    public init(
        id: UInt64
    ) {
        let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
        
        self.identifier = id
        
        CGSShowSpaces(
            _CGSDefaultConnection(),
            [self.identifier]
        )
        
        self.createdByInit = false // Mark as created externally
    }

    deinit {
        CGSHideSpaces(
            _CGSDefaultConnection(),
            [self.identifier]
        )
        
        if createdByInit {
            CGSSpaceDestroy(
                _CGSDefaultConnection(),
                self.identifier
            )
        }
    }
}

// CGSSpace stuff:
fileprivate typealias CGSConnectionID = UInt
fileprivate typealias CGSSpaceID = UInt64
@_silgen_name("_CGSDefaultConnection")
fileprivate func _CGSDefaultConnection() -> CGSConnectionID
@_silgen_name("CGSSpaceCreate")
fileprivate func CGSSpaceCreate(_ cid: CGSConnectionID, _ unknown: Int, _ options: NSDictionary?) -> CGSSpaceID
@_silgen_name("CGSSpaceDestroy")
fileprivate func CGSSpaceDestroy(_ cid: CGSConnectionID, _ space: CGSSpaceID)
@_silgen_name("CGSSpaceSetAbsoluteLevel")
fileprivate func CGSSpaceSetAbsoluteLevel(_ cid: CGSConnectionID, _ space: CGSSpaceID, _ level: Int)
@_silgen_name("CGSAddWindowsToSpaces")
fileprivate func CGSAddWindowsToSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSRemoveWindowsFromSpaces")
fileprivate func CGSRemoveWindowsFromSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSHideSpaces")
fileprivate func CGSHideSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
@_silgen_name("CGSShowSpaces")
fileprivate func CGSShowSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
