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
    var isPrimaryScreen: Bool {
        guard let screen else { return true }
        let hasHardwareNotchScreen = NSScreen.screens.contains { NotchUtils.shared.hasNotch(screen: $0) }
        if hasHardwareNotchScreen {
            return NotchUtils.shared.hasNotch(screen: screen)
        }
        if let primary = NSScreen.screens.first {
            return screen == primary
        }
        return true
    }

    var isSecondaryScreen: Bool {
        !isPrimaryScreen
    }

    var isAuxiliaryScreen: Bool {
        isSecondaryScreen && NotchDefaults.shared.externalNotchStyle == .hud
    }

    var shouldShowHUDOnThisScreen: Bool {
        guard let screen else { return true }
        return NotchManager.shared.shouldShowOnScreen(screen)
    }

    func shouldHandleDisplayTargetedNotification(targetDisplayID: CGDirectDisplayID?) -> Bool {
        let currentDisplayID = screen?.displayID ?? 0
        let targetID = targetDisplayID ?? 0

        // If no target display specified, or targeted to main display:
        // Main display handles it; secondary displays do not.
        if targetID == 0 {
            return isPrimaryScreen
        }

        if isPrimaryScreen {
            if targetID == currentDisplayID {
                return true
            }

            // Targeted to a secondary screen: fallback to main display if that screen doesn't show notch
            if let targetScreen = NSScreen.screens.first(where: { $0.displayID == targetID }),
               !NotchManager.shared.shouldShowOnScreen(targetScreen) {
                return true
            }

            return false
        } else {
            // Secondary screen: handle if targeted to this exact display
            return targetID == currentDisplayID
        }
    }

    @objc func handleBetterDisplayOSDNotification(_ notification: Notification) {
        guard let osdInfo = notification.object as? BetterDisplayOSDNotification,
              shouldHandleDisplayTargetedNotification(targetDisplayID: osdInfo.displayID) else {
            return
        }

        let target = osdInfo.controlTarget?.lowercased() ?? ""
        let iconID = osdInfo.systemIconID ?? 0
        let isBrightness = target.contains("brightness") || iconID == 1

        // Auxiliary screens only support brightness HUD
        if isAuxiliaryScreen, !isBrightness {
            return
        }

        let rawVal = osdInfo.value ?? 0
        let maxVal = osdInfo.maxValue ?? (rawVal > 1.0 ? 100.0 : 1.0)
        let normalizedVal: Float = maxVal > 0 ? Float(rawVal / maxVal) : Float(rawVal)

        // Handle Brightness HUD
        if isBrightness {
            guard HUDBrightnessDefaults.shared.isEnabled,
                  !isCurrentlyLocked || NotchDefaults.shared.lockScreenShowBrightnessHUD
            else { return }

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
            guard HUDAudioOutputDefaults.shared.isEnabled,
                  !isCurrentlyLocked || NotchDefaults.shared.lockScreenShowAudioOutputHUD
            else { return }

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
        guard HUDBrightnessDefaults.shared.isEnabled,
              !isCurrentlyLocked || NotchDefaults.shared.lockScreenShowBrightnessHUD
        else {
            return
        }

        let targetDisplayID = (notification.userInfo?["display"] as? NSNumber)?.uint32Value
            ?? (notification.userInfo?["displayID"] as? NSNumber)?.uint32Value

        guard shouldHandleDisplayTargetedNotification(targetDisplayID: targetDisplayID) else {
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

    @objc func screenLocked(notification _: Notification) {
        if !NotchDefaults.shared.lockScreenShowBrightnessHUD {
            brightnessHUD = nil
        }
        if !NotchDefaults.shared.lockScreenShowAudioOutputHUD {
            outputAudioVolumeHUD = nil
            outputAudioDeviceHUD = nil
        }
        if !NotchDefaults.shared.lockScreenShowAudioInputHUD {
            inputAudioVolumeHUD = nil
            inputAudioDeviceHUD = nil
        }
        if !NotchDefaults.shared.lockScreenShowPowerHUD {
            powerStatusHUD = nil
        }
        if !NotchDefaults.shared.lockScreenShowMediaHUD {
            nowPlayingChangesHUD = nil
        }

        guard NotchDefaults.shared.lockScreenShowLockStatusHUD else { return }
        lockStatusHUD?.timer?.invalidate()
        withAnimation {
            self.lockStatusHUD = .init(
                lottie: AppAnimation.brightness,
                icon: AppAsset.speaker,
                name: "Screen Locked",
                value: 1.0,
                timer: nil
            )
        }
    }

    @objc func screenUnlocked(notification _: Notification) {
        guard NotchDefaults.shared.lockScreenShowLockStatusHUD else { return }
        withAnimation {
            self.lockStatusHUD?.name = "Screen Unlocked"
            self.lockStatusHUD?.value = 0.0
        }

        resetHUDTimer(&lockStatusHUD) {
            withAnimation {
                self.lockStatusHUD = nil
            }
        }
    }
}
