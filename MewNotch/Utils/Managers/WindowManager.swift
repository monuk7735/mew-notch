//
//  WindowManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/06/25.
//

// Inspired From: https://github.com/Lakr233/SkyLightWindow/blob/main/Sources/SkyLightWindow/SkyLightOperator.swift

import SwiftUI

public class WindowManager {
    
    enum CGSSpaceLevel: Int32 {
        case kCGSSpaceAbsoluteLevelDefault = 0
        case kCGSSpaceAbsoluteLevelSetupAssistant = 100
        case kCGSSpaceAbsoluteLevelSecurityAgent = 200
        case kCGSSpaceAbsoluteLevelScreenLock = 300
        case kSLSSpaceAbsoluteLevelNotificationCenterAtScreenLock = 400
        case kCGSSpaceAbsoluteLevelBootProgress = 500
        case kCGSSpaceAbsoluteLevelVoiceOver = 600
    }
    
    public static let shared = WindowManager()

    private let connection: Int32
    private let space: Int32

    private let SLSMainConnectionID: @convention(c) () -> Int32
    private let SLSSpaceCreate: @convention(c) (Int32, Int32, Int32) -> Int32
    private let SLSSpaceSetAbsoluteLevel: @convention(c) (Int32, Int32, Int32) -> Int32
    private let SLSShowSpaces: @convention(c) (Int32, CFArray) -> Int32
    private let SLSSpaceAddWindowsAndRemoveFromSpaces: @convention(c) (Int32, Int32, CFArray, Int32) -> Int32

    private init() {
        let handler = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight", RTLD_NOW)
        
        SLSMainConnectionID = unsafeBitCast(
            dlsym(
                handler,
                "SLSMainConnectionID"
            ),
            to: type(
                of: SLSMainConnectionID
            )
        )
        
        SLSSpaceCreate = unsafeBitCast(
            dlsym(
                handler,
                "SLSSpaceCreate"
            ),
            to: type(
                of: SLSSpaceCreate
            )
        )
        
        SLSSpaceSetAbsoluteLevel = unsafeBitCast(
            dlsym(
                handler,
                "SLSSpaceSetAbsoluteLevel"
            ),
            to: type(
                of: SLSSpaceSetAbsoluteLevel
            )
        )
        
        SLSShowSpaces = unsafeBitCast(
            dlsym(
                handler,
                "SLSShowSpaces"
            ),
            to: type(
                of: SLSShowSpaces
            )
        )
        
        SLSSpaceAddWindowsAndRemoveFromSpaces = unsafeBitCast(
            dlsym(
                handler,
                "SLSSpaceAddWindowsAndRemoveFromSpaces"
            ),
            to: type(
                of: SLSSpaceAddWindowsAndRemoveFromSpaces
            )
        )

        connection = SLSMainConnectionID()
        space = SLSSpaceCreate(
            connection,
            1,
            0
        )
        
        let _ = SLSSpaceSetAbsoluteLevel(
            connection,
            space,
            CGSSpaceLevel.kSLSSpaceAbsoluteLevelNotificationCenterAtScreenLock.rawValue
        )
        
        let _ = SLSShowSpaces(
            connection,
            [space] as CFArray
        )
    }

    func moveToLockScreen(
        _ window: NSWindow
    ) {
        let _ = SLSSpaceAddWindowsAndRemoveFromSpaces(
            connection,
            space,
            [window.windowNumber] as CFArray,
            7
        )
    }
}
