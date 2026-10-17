//
//  CollapsedNotchViewModel+Display.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import AppKit
import Foundation
import SwiftUI

extension CollapsedNotchViewModel {
    var isAuxiliaryScreen: Bool {
        guard let screen else { return false }
        let hasHardwareNotchScreen = NSScreen.screens.contains { NotchUtils.shared.hasNotch(screen: $0) }
        if hasHardwareNotchScreen {
            return !NotchUtils.shared.hasNotch(screen: screen)
        }
        if let primary = NSScreen.screens.first {
            return screen != primary
        }
        return false
    }

    var shouldShowHUDOnThisScreen: Bool {
        if isAuxiliaryScreen, !NotchDefaults.shared.showHUDOnAuxiliaryScreens {
            return false
        }
        return true
    }

    @objc func handleBetterDisplayOSDNotification(_ notification: Notification) {
        guard let osdInfo = notification.object as? BetterDisplayOSDNotification else { return }

        // Display targeting:
        // If BetterDisplay specifies a target displayID, verify against this screen's displayID.
        var isTargetedForThisDisplay = false
        if let targetDisplayID = osdInfo.displayID,
           let currentDisplayID = screen?.displayID,
           targetDisplayID != 0 {
            if targetDisplayID != currentDisplayID {
                return
            }
            isTargetedForThisDisplay = true
        }

        let target = osdInfo.controlTarget?.lowercased() ?? ""
        let iconID = osdInfo.systemIconID ?? 0
        let isBrightness = target.contains("brightness") || iconID == 1

        // Brightness HUDs specifically targeted for this display are excluded from auxiliary suppression
        if !shouldShowHUDOnThisScreen, !(isBrightness && isTargetedForThisDisplay) {
            return
        }

        let rawVal = osdInfo.value ?? 0
        let maxVal = osdInfo.maxValue ?? (rawVal > 1.0 ? 100.0 : 1.0)
        let normalizedVal: Float = maxVal > 0 ? Float(rawVal / maxVal) : Float(rawVal)

        // Handle Brightness HUD
        if isBrightness {
            guard HUDBrightnessDefaults.shared.isEnabled else { return }

            withAnimation {
                self.brightnessHUD = .init(
                    lottie: AppAnimation.brightness,
                    icon: AppAsset.brightness,
                    name: osdInfo.text ?? "Brightness",
                    value: normalizedVal,
                    timer: brightnessHUD?.timer
                )
            }

            resetHUDTimer(&brightnessHUD) {
                withAnimation {
                    self.brightnessHUD = nil
                }
            }
        } else if target.contains("volume") || target.contains("sound") || target.contains("mute") || iconID == 3 || iconID == 4 {
            guard HUDAudioOutputDefaults.shared.isEnabled else { return }

            let isMuted = iconID == 4 || target.contains("mute")

            withAnimation {
                self.outputAudioVolumeHUD = .init(
                    lottie: isMuted ? nil : AppAnimation.speaker,
                    icon: AppAsset.speaker,
                    name: osdInfo.text ?? (isMuted ? "Muted" : "Output Volume"),
                    value: isMuted ? 0.0 : normalizedVal,
                    timer: outputAudioVolumeHUD?.timer
                )
            }

            resetHUDTimer(&outputAudioVolumeHUD) {
                withAnimation {
                    self.outputAudioVolumeHUD = nil
                }
            }
        }
    }

    @objc func handleBrightnessChanges(_ notification: NSNotification) {
        guard HUDBrightnessDefaults.shared.isEnabled else {
            return
        }

        let targetDisplayID = (notification.userInfo?["display"] as? NSNumber)?.uint32Value
            ?? (notification.userInfo?["displayID"] as? NSNumber)?.uint32Value
        let currentDisplayID = screen?.displayID

        if let targetDisplayID, targetDisplayID != 0, let currentDisplayID {
            if targetDisplayID != currentDisplayID {
                return
            }
        } else if !shouldShowHUDOnThisScreen {
            return
        }

        var newBrightness: Float! = (notification.userInfo?["value"] as? Float)
        newBrightness = newBrightness ?? Brightness.sharedInstance().brightness

        defer {
            lastBrightness = newBrightness
        }

        if !HUDBrightnessDefaults.shared.showAutoBrightnessChanges, abs(lastBrightness - newBrightness) < 0.01 {
            withAnimation {
                self.brightnessHUD?.value = newBrightness
            }
            return
        }

        withAnimation {
            self.brightnessHUD = .init(
                lottie: AppAnimation.brightness,
                icon: AppAsset.brightness,
                name: "Brightness",
                value: newBrightness,
                timer: brightnessHUD?.timer
            )
        }

        resetHUDTimer(&brightnessHUD) {
            withAnimation {
                self.brightnessHUD = nil
            }
        }
    }
}
