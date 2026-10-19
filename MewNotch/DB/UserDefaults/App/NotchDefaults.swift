//
//  NotchDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class NotchDefaults: ObservableObject {
    private static var PREFIX: String = "Notch_"

    static let shared = NotchDefaults()

    private init() {
        var currentOrder = expandedItemsOrder
        let allItems = ExpandedNotchItem.allCases

        let missingItems = allItems.filter { !currentOrder.contains($0) }

        if !missingItems.isEmpty {
            currentOrder.append(contentsOf: missingItems)
            expandedItemsOrder = currentOrder
        }

        if let legacyReset = UserDefaults.standard.object(forKey: Self.PREFIX + "resetViewOnCollapse") as? Bool {
            if UserDefaults.standard.object(forKey: Self.PREFIX + "DefaultView") == nil {
                defaultView = legacyReset ? .home : .lastUsed
            }
            UserDefaults.standard.removeObject(forKey: Self.PREFIX + "resetViewOnCollapse")
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "HideOnFullScreen",
        defaultValue: true
    )
    var hideOnFullScreen: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "NotchDisplayVisibility",
        defaultValue: NotchDisplayVisibility.notchedDisplayOnly
    )
    var notchDisplayVisibility: NotchDisplayVisibility {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ShownOnDisplay",
        defaultValue: [:]
    )
    var shownOnDisplay: [String: Bool] {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ExternalNotchStyle",
        defaultValue: ExternalNotchStyle.hudOnly
    )
    var externalNotchStyle: ExternalNotchStyle {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "ExternalHUDTopOffset",
        defaultValue: 8.0
    )
    var externalHUDTopOffset: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "FloatingIslandTopOffset",
        defaultValue: 8.0
    )
    var floatingIslandTopOffset: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "FloatingIslandWidth",
        defaultValue: 180.0
    )
    var floatingIslandWidth: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "FloatingIslandHeightOffset",
        defaultValue: 0.0
    )
    var floatingIslandHeightOffset: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "YieldBrightnessToBetterDisplay",
        defaultValue: true
    )
    var yieldBrightnessToBetterDisplay: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "ShownOnLockScreen",
        defaultValue: true
    )
    var shownOnLockScreen: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowAudioOutputHUD",
        defaultValue: true
    )
    var lockScreenShowAudioOutputHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowAudioInputHUD",
        defaultValue: true
    )
    var lockScreenShowAudioInputHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowBrightnessHUD",
        defaultValue: true
    )
    var lockScreenShowBrightnessHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowPowerHUD",
        defaultValue: true
    )
    var lockScreenShowPowerHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowMediaHUD",
        defaultValue: true
    )
    var lockScreenShowMediaHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "LockScreen_ShowLockStatusHUD",
        defaultValue: true
    )
    var lockScreenShowLockStatusHUD: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "DefaultView",
        defaultValue: NotchDefaultView.home
    )
    var defaultView: NotchDefaultView {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "GlassEffect",
        defaultValue: false
    )
    var applyGlassEffect: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "ExpandOnHover",
        defaultValue: false
    )
    var expandOnHover: Bool {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "ExpandOnHoverDelay",
        defaultValue: 0.5
    )
    var expandOnHoverDelay: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "HapticFeedback",
        defaultValue: true
    )
    var hapticFeedback: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "ExpandedNotchShowDividers",
        defaultValue: true
    )
    var showDividers: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ExpandedNotchItems",
        defaultValue: [
            ExpandedNotchItem.mirror,
            ExpandedNotchItem.nowPlaying
        ]
    )
    var expandedNotchItems: [ExpandedNotchItem] {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "ExpandedItemsOrder",
        defaultValue: ExpandedNotchItem.allCases
    )
    var expandedItemsOrder: [ExpandedNotchItem] {
        didSet {
            objectWillChange.send()
        }
    }
}
