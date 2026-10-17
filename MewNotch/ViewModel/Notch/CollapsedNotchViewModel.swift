//
//  CollapsedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Lottie
import SwiftUI

class CollapsedNotchViewModel: ObservableObject {
    @Published var nowPlayingMedia: NowPlayingMediaModel?

    @Published var outputAudioVolumeHUD: HUDPropertyModel?
    @Published var outputAudioDeviceHUD: HUDPropertyModel?

    @Published var inputAudioVolumeHUD: HUDPropertyModel?
    @Published var inputAudioDeviceHUD: HUDPropertyModel?

    @Published var brightnessHUD: HUDPropertyModel?

    @Published var powerStatusHUD: HUDPropertyModel?

    @Published var lockStatusHUD: HUDPropertyModel?
    @Published var nowPlayingChangesHUD: HUDPropertyModel?

    @Published var lastPowerStatus: String = ""
    @Published var lastBrightness: Float = 0.0
    @Published var lastAudioInputVolume: Float = 0.0
    private let volumeHUDThreshold: Float = 0.04
    var screen: NSScreen?

    var hasActiveHUD: Bool {
        outputAudioVolumeHUD != nil ||
            outputAudioDeviceHUD != nil ||
            inputAudioVolumeHUD != nil ||
            inputAudioDeviceHUD != nil ||
            brightnessHUD != nil ||
            powerStatusHUD != nil ||
            lockStatusHUD != nil ||
            nowPlayingChangesHUD != nil
    }

    init(screen: NSScreen? = nil) {
        self.screen = screen
        startListeners()

        // Use existing model when Notch is refreshed
        if NowPlaying.shared.playing {
            nowPlayingMedia = NowPlaying.shared.nowPlayingModel
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func resetHUDTimer(
        _ hud: inout HUDPropertyModel?,
        onComplete: @escaping () -> Void
    ) {
        hud?.timer?.invalidate()
        let timeout = hud?.timeout ?? 1.0

        hud?.timer = .scheduledTimer(
            withTimeInterval: timeout,
            repeats: false
        ) { _ in
            onComplete()
        }
    }

    func hideHUDs() {
        withAnimation {
            self.outputAudioVolumeHUD = nil
            self.outputAudioDeviceHUD = nil

            self.inputAudioVolumeHUD = nil
            self.inputAudioDeviceHUD = nil

            self.brightnessHUD = nil

            self.powerStatusHUD = nil

            self.nowPlayingChangesHUD = nil
        }
    }

    func startListeners() {
        // MARK: Input Audio Change Listeners

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInputVolumeChanges),
            name: NSNotification.Name.AudioInputVolume,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInputDeviceChanges),
            name: NSNotification.Name.AudioInputDevice,
            object: nil
        )

        // MARK: Output Audio Change Listeners

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioOutputVolumeChanges),
            name: NSNotification.Name.AudioOutputVolume,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioOutputDeviceChanges),
            name: NSNotification.Name.AudioOutputDevice,
            object: nil
        )

        // MARK: Brightness Change Listener

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBrightnessChanges(_:)),
            name: NSNotification.Name.Brightness,
            object: nil
        )

        // MARK: Power Source Change Listener

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePowerStatusChanges),
            name: NSNotification.Name.PowerStatus,
            object: nil
        )

        // MARK: Media Change Listeners

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenLocked),
            name: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil
        )

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenUnlocked),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
        
        // MARK: BetterDisplay Integration
        _ = BetterDisplayManager.shared
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBetterDisplayOSDNotification(_:)),
            name: .BetterDisplayOSD,
            object: nil
        )
    }

    @objc func screenLocked(notification _: Notification) {
        withAnimation {
            self.lockStatusHUD = .init(
                lottie: AppAnimation.brightness,
                icon: AppAsset.speaker,
                name: "Screen Locked",
                value: 1.0,
                timer: lockStatusHUD?.timer
            )
        }
    }

    @objc func screenUnlocked(notification _: Notification) {
        withAnimation {
            self.lockStatusHUD?.value = 0.0
        }

        resetHUDTimer(&lockStatusHUD) {
            withAnimation {
                self.lockStatusHUD = nil
            }
        }
    }

    @objc private func handleAudioInputDeviceChanges() {
        if !HUDAudioInputDefaults.shared.isEnabled {
            return
        }

        withAnimation {
            self.inputAudioDeviceHUD = .init(
                lottie: nil,
                icon: AppAsset.speaker,
                name: AudioInput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: inputAudioDeviceHUD?.timer
            )
        }

        resetHUDTimer(&inputAudioDeviceHUD) {
            withAnimation {
                self.inputAudioDeviceHUD = nil
            }
        }
    }

    @objc private func handleAudioInputVolumeChanges() {
        if !HUDAudioInputDefaults.shared.isEnabled {
            return
        }

        let newVolume = VolumeManager.shared.getInputVolume()

        guard newVolume != lastAudioInputVolume,
              abs(lastAudioInputVolume - newVolume) >= volumeHUDThreshold
        else {
            return
        }

        lastAudioInputVolume = newVolume

        if inputAudioVolumeHUD != nil {
            withAnimation {
                self.inputAudioVolumeHUD?.value = newVolume
            }

            resetHUDTimer(&inputAudioVolumeHUD) {
                withAnimation {
                    self.inputAudioVolumeHUD = nil
                }
            }

            return
        }

        withAnimation {
            self.inputAudioVolumeHUD = .init(
                lottie: nil,
                icon: AppIcon.microphoneFill.image,
                name: NSLocalizedString("Input Volume", comment: ""),
                value: newVolume,
                timer: inputAudioVolumeHUD?.timer
            )
        }

        resetHUDTimer(&inputAudioVolumeHUD) {
            withAnimation {
                self.inputAudioVolumeHUD = nil
            }
        }
    }

    @objc private func handleAudioOutputDeviceChanges() {
        if !HUDAudioOutputDefaults.shared.isEnabled {
            return
        }

        withAnimation {
            self.outputAudioDeviceHUD = .init(
                lottie: nil,
                icon: AppAsset.speaker,
                name: AudioOutput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: outputAudioDeviceHUD?.timer
            )
        }

        resetHUDTimer(&outputAudioDeviceHUD) {
            withAnimation {
                self.outputAudioDeviceHUD = nil
            }
        }
    }

    @objc private func handleAudioOutputVolumeChanges() {
        if !HUDAudioOutputDefaults.shared.isEnabled {
            return
        }

        withAnimation {
            self.outputAudioVolumeHUD = .init(
                lottie: AppAnimation.speaker,
                icon: AppAsset.speaker,
                name: NSLocalizedString("Output Volume", comment: ""),
                value: VolumeManager.shared.getOutputVolume(),
                timer: outputAudioVolumeHUD?.timer
            )
        }

        resetHUDTimer(&outputAudioVolumeHUD) {
            withAnimation {
                self.outputAudioVolumeHUD = nil
            }
        }
    }

    @objc private func handleBrightnessChanges(
        _ notification: NSNotification
    ) {
        if !HUDBrightnessDefaults.shared.isEnabled {
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

    @objc private func handlePowerStatusChanges() {
        if !HUDPowerDefaults.shared.showTimeRemaining {
            return
        }

        if lastPowerStatus == PowerStatus.sharedInstance().providingSource() {
            return
        }

        lastPowerStatus = PowerStatus.sharedInstance().providingSource()
        let isCharging = PowerStatus.sharedInstance().providingSource() == PowerStatusACPower

        var batteryLevelForIcon = Int(PowerStatus.sharedInstance().getBatteryLevel() * 100)
        batteryLevelForIcon -= (batteryLevelForIcon % 25)

        withAnimation {
            self.powerStatusHUD = .init(
                lottie: nil,
                icon: .init(
                    systemName: isCharging
                        ? "battery.100percent.bolt" : "battery.\(batteryLevelForIcon)percent"
                ),
                name: PowerStatus.sharedInstance().providingSource(),
                value: Float(PowerStatus.sharedInstance().remainingTime()),
                timeout: PowerStatus.sharedInstance().remainingTime().isFinite ? 3.0 : 1.0,
                timer: powerStatusHUD?.timer
            )
        }

        resetHUDTimer(&powerStatusHUD) {
            withAnimation {
                self.powerStatusHUD = nil
            }
        }
    }

    @objc func handleNowPlayingMediaChanges() {
        if !NowPlaying.shared.playing {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                if NowPlaying.shared.playing {
                    return
                }

                withAnimation {
                    self.nowPlayingMedia = nil
                }
            }
        }

        guard let nowPlayingMedia = NowPlaying.shared.nowPlayingModel else {
            return
        }

        let titleChanged = self.nowPlayingMedia?.title != nowPlayingMedia.title

        DispatchQueue.main.async {
            withAnimation {
                self.nowPlayingMedia = nowPlayingMedia

                if titleChanged, !nowPlayingMedia.title.isEmpty, HUDMediaDefaults.shared.isEnabled {
                    self.nowPlayingChangesHUD = .init(
                        lottie: nil,
                        icon: AppAsset.speaker,
                        name: nowPlayingMedia.title,
                        value: 0.0,
                        timeout: HUDMediaDefaults.shared.titleChangeTimeout,
                        timer: self.nowPlayingChangesHUD?.timer
                    )

                    self.resetHUDTimer(&self.nowPlayingChangesHUD) {
                        withAnimation {
                            self.nowPlayingChangesHUD = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - BetterDisplay OSD Handler
    
    @objc private func handleBetterDisplayOSDNotification(_ notification: Notification) {
        guard let osdInfo = notification.object as? BetterDisplayOSDNotification else { return }
        
        // Display targeting:
        // If BetterDisplay specifies a target displayID, verify against this screen's displayID.
        if let targetDisplayID = osdInfo.displayID,
           let currentDisplayID = self.screen?.displayID,
           targetDisplayID != 0 {
            if targetDisplayID != currentDisplayID {
                return
            }
        }
        
        let target = osdInfo.controlTarget?.lowercased() ?? ""
        let iconID = osdInfo.systemIconID ?? 0
        
        let rawVal = osdInfo.value ?? 0
        let maxVal = osdInfo.maxValue ?? (rawVal > 1.0 ? 100.0 : 1.0)
        let normalizedVal: Float = maxVal > 0 ? Float(rawVal / maxVal) : Float(rawVal)
        
        // Handle Brightness HUD
        if target.contains("brightness") || iconID == 1 {
            if !HUDBrightnessDefaults.shared.isEnabled { return }
            
            withAnimation {
                self.brightnessHUD = .init(
                    lottie: AppAnimation.brightness,
                    icon: AppAsset.brightness,
                    name: osdInfo.text ?? "Brightness",
                    value: normalizedVal,
                    timer: brightnessHUD?.timer
                )
            }

            self.resetHUDTimer(&self.brightnessHUD) {
                withAnimation {
                    self.brightnessHUD = nil
                }
            }
        }
        // Handle Volume HUD
        else if target.contains("volume") || target.contains("sound") || target.contains("mute") || iconID == 3 || iconID == 4 {
            if !HUDAudioOutputDefaults.shared.isEnabled { return }

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
            
            self.resetHUDTimer(&self.outputAudioVolumeHUD) {
                withAnimation {
                    self.outputAudioVolumeHUD = nil
                }
            }
        }
    }
}
