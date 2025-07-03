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
    private let SLSSpaceDestroy: @convention(c) (Int32, Int32) -> Int32
    
    private let SLSSpaceSetAbsoluteLevel: @convention(c) (Int32, Int32, Int32) -> Int32
    
    private let SLSShowSpaces: @convention(c) (Int32, CFArray) -> Int32
    private let SLSHideSpaces: @convention(c) (Int32, CFArray) -> Int32
    
    private let SLSSpaceAddWindowsAndRemoveFromSpaces: @convention(c) (Int32, Int32, CFArray, Int32) -> Int32

    private init?() {
        guard let bundle = CFBundleCreate(
            kCFAllocatorDefault,
            NSURL(
                fileURLWithPath: "/System/Library/PrivateFrameworks/SkyLight.framework"
            )
        ) else {
            return nil
        }
        
        guard let SLSMainConnectionIDPointer = CFBundleGetFunctionPointerForName(bundle, "SLSMainConnectionID" as CFString) else { return nil }
        typealias SLSMainConnectionIDAlias = @convention(c) () -> Int32
        SLSMainConnectionID = unsafeBitCast(
            SLSMainConnectionIDPointer,
            to: SLSMainConnectionIDAlias.self
        )
        
        guard let SLSSpaceCreatePointer = CFBundleGetFunctionPointerForName(bundle, "SLSSpaceCreate" as CFString) else { return nil }
        typealias SLSSpaceCreateAlias = @convention(c) (Int32, Int32, Int32) -> Int32
        SLSSpaceCreate = unsafeBitCast(
            SLSSpaceCreatePointer,
            to: SLSSpaceCreateAlias.self
        )
        
        guard let SLSSpaceDestroyPointer = CFBundleGetFunctionPointerForName(bundle, "SLSSpaceDestroy" as CFString) else { return nil }
        typealias SLSSpaceDestroyAlias = @convention(c) (Int32, Int32) -> Int32
        SLSSpaceDestroy = unsafeBitCast(
            SLSSpaceDestroyPointer,
            to: SLSSpaceDestroyAlias.self
        )
        
        guard let SLSSpaceSetAbsoluteLevelPointer = CFBundleGetFunctionPointerForName(bundle, "SLSSpaceSetAbsoluteLevel" as CFString) else { return nil }
        typealias SLSSpaceSetAbsoluteLevelAlias = @convention(c) (Int32, Int32, Int32) -> Int32
        SLSSpaceSetAbsoluteLevel = unsafeBitCast(
            SLSSpaceSetAbsoluteLevelPointer,
            to: SLSSpaceSetAbsoluteLevelAlias.self
        )
        
        guard let SLSShowSpacesPointer = CFBundleGetFunctionPointerForName(bundle, "SLSShowSpaces" as CFString) else { return nil }
        typealias SLSShowSpacesAlias = @convention(c) (Int32, CFArray) -> Int32
        SLSShowSpaces = unsafeBitCast(
            SLSShowSpacesPointer,
            to: SLSShowSpacesAlias.self
        )
        
        guard let SLSHideSpacesPointer = CFBundleGetFunctionPointerForName(bundle, "SLSHideSpaces" as CFString) else { return nil }
        typealias SLSHideSpacesAlias = @convention(c) (Int32, CFArray) -> Int32
        SLSHideSpaces = unsafeBitCast(
            SLSHideSpacesPointer,
            to: SLSHideSpacesAlias.self
        )
        
        guard let SLSSpaceAddWindowsAndRemoveFromSpacesPointer = CFBundleGetFunctionPointerForName(bundle, "SLSSpaceAddWindowsAndRemoveFromSpaces" as CFString) else { return nil }
        typealias SLSSpaceAddWindowsAndRemoveFromSpacesAlias = @convention(c) (Int32, Int32, CFArray, Int32) -> Int32
        SLSSpaceAddWindowsAndRemoveFromSpaces = unsafeBitCast(
            SLSSpaceAddWindowsAndRemoveFromSpacesPointer,
            to: SLSSpaceAddWindowsAndRemoveFromSpacesAlias.self
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
    
    deinit {
        let _ = SLSHideSpaces(
            connection,
            [space] as CFArray
        )
        
        let _ = SLSSpaceDestroy(
            connection,
            space
        )
    }

    func moveToLockScreen(
        _ window: NSWindow
    ) {
        /**
         Last arg is a option for what to do (ig)
         7 = 0b0111 = Remove, Add, Animate
         3 = 0b0011 = Remove, Add (no animation)
        */
        if #available(macOS 16, *) { // 26 won't work idk why
//            let _ = SLSSpaceAddWindowsAndRemoveFromSpaces(
//                connection,
//                space,
//                [window.windowNumber] as CFArray,
//                3
//            )
        } else {
            // Keeping same for older version as it was working fine.
            let _ = SLSSpaceAddWindowsAndRemoveFromSpaces(
                connection,
                space,
                [window.windowNumber] as CFArray,
                7
            )
        }
    }
}
