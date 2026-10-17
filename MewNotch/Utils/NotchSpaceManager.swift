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
        notchSpace = CGSSpace(level: 2_147_483_647) // Max level
    }
}

public final class CGSSpace {
    private let identifier: CGSSpaceID
    private let createdByInit: Bool

    public var windows: Set<NSWindow> = [] {
        didSet {
            let remove = oldValue.subtracting(
                windows
            )

            let add = windows.subtracting(
                oldValue
            )

            CGSRemoveWindowsFromSpaces(
                _CGSDefaultConnection(),
                remove.map(\.windowNumber) as CFArray,
                [identifier] as CFArray
            )

            CGSAddWindowsToSpaces(
                _CGSDefaultConnection(),
                add.map(\.windowNumber) as CFArray,
                [identifier] as CFArray
            )
        }
    }

    /// Initialized `CGSSpace`s *MUST* be de-initialized upon app exit!
    public init(
        level: Int = 0
    ) {
        let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
        identifier = CGSSpaceCreate(
            _CGSDefaultConnection(),
            flag,
            nil
        )

        CGSSpaceSetAbsoluteLevel(
            _CGSDefaultConnection(),
            identifier,
            level
        )

        CGSShowSpaces(
            _CGSDefaultConnection(),
            [identifier]
        )

        createdByInit = true // Mark as created by the first init
    }

    public init(
        id: UInt64
    ) {
        identifier = id

        CGSShowSpaces(
            _CGSDefaultConnection(),
            [identifier]
        )

        createdByInit = false // Mark as created externally
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
private typealias CGSConnectionID = UInt
private typealias CGSSpaceID = UInt64
@_silgen_name("_CGSDefaultConnection")
private func _CGSDefaultConnection() -> CGSConnectionID
@_silgen_name("CGSSpaceCreate")
private func CGSSpaceCreate(_ cid: CGSConnectionID, _ unknown: Int, _ options: NSDictionary?) -> CGSSpaceID
@_silgen_name("CGSSpaceDestroy")
private func CGSSpaceDestroy(_ cid: CGSConnectionID, _ space: CGSSpaceID)
@_silgen_name("CGSSpaceSetAbsoluteLevel")
private func CGSSpaceSetAbsoluteLevel(_ cid: CGSConnectionID, _ space: CGSSpaceID, _ level: Int)
@_silgen_name("CGSAddWindowsToSpaces")
private func CGSAddWindowsToSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSRemoveWindowsFromSpaces")
private func CGSRemoveWindowsFromSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSHideSpaces")
private func CGSHideSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
@_silgen_name("CGSShowSpaces")
private func CGSShowSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
