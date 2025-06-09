//
//  CollapsedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

class CollapsedNotchViewModel: ObservableObject {
    
    @Published var nowPlayingMedia: NowPlayingMediaModel?
    
    @Published var outputAudioVolumeHUD: HUDPropertyModel?
    @Published var outputAudioDeviceHUD: HUDPropertyModel?
    
    @Published var inputAudioVolumeHUD: HUDPropertyModel?
    @Published var inputAudioDeviceHUD: HUDPropertyModel?
    
    @Published var brightnessHUD: HUDPropertyModel?
    
    @Published var powerStatusHUD: HUDPropertyModel?
    
    @Published var lockStatusHUD: HUDPropertyModel?
    
    @Published var lastPowerStatus: String = ""
    
    init() {
        self.startListeners()
    }
    
    deinit {
        self.stopListeners()
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
            selector: #selector(handleBrightnessChanges),
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingState,
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
    }
    
    @objc func screenLocked(notification: Notification) {
        withAnimation {
            self.lockStatusHUD = .init(
                lottie: MewNotch.Lotties.brightness,
                icon: MewNotch.Assets.iconSpeaker,
                name: "Screen Locked",
                value: 1.0,
                timer: lockStatusHUD?.timer
            )
        }
    }
    
    @objc func screenUnlocked(notification: Notification) {
        withAnimation {
            self.lockStatusHUD?.value = 0.0
        }
        
        self.resetHUDTimer(&self.lockStatusHUD) {
            withAnimation {
                self.lockStatusHUD = nil
            }
        }
    }

    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
        
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    @objc private func handleAudioInputDeviceChanges() {
        if !HUDAudioInputDefaults.shared.isEnabled {
            return
        }
        
        withAnimation {
            self.inputAudioDeviceHUD = .init(
                lottie: nil,
                icon: MewNotch.Assets.iconSpeaker,
                name: AudioInput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: inputAudioDeviceHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.inputAudioDeviceHUD) {
            withAnimation {
                self.inputAudioDeviceHUD = nil
            }
        }
    }
    
    @objc private func handleAudioInputVolumeChanges() {
        if !HUDAudioInputDefaults.shared.isEnabled {
            return
        }
        
        withAnimation {
            self.inputAudioVolumeHUD = .init(
                lottie: nil,
                icon: .init(systemName: "microphone.fill"),
                name: "Input Volume",
                value: VolumeManager.shared.getInputVolume(),
                timer: inputAudioVolumeHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.inputAudioVolumeHUD) {
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
                icon: MewNotch.Assets.iconSpeaker,
                name: AudioOutput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: outputAudioDeviceHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.outputAudioDeviceHUD) {
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
                lottie: MewNotch.Lotties.speaker,
                icon: MewNotch.Assets.iconSpeaker,
                name: "Output Volume",
                value: VolumeManager.shared.getOutputVolume(),
                timer: outputAudioVolumeHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.outputAudioVolumeHUD) {
            withAnimation {
                self.outputAudioVolumeHUD = nil
            }
        }
    }
    
    @objc private func handleBrightnessChanges() {
        if !HUDBrightnessDefaults.shared.isEnabled {
            return
        }
        
        withAnimation {
            self.brightnessHUD = .init(
                lottie: MewNotch.Lotties.brightness,
                icon: MewNotch.Assets.iconBrightness,
                name: "Brightness",
                value: Brightness.sharedInstance().brightness,
                timer: brightnessHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.brightnessHUD) {
            withAnimation {
                self.brightnessHUD = nil
            }
        }
    }
    
    @objc private func handlePowerStatusChanges() {
        if lastPowerStatus == PowerStatus.sharedInstance().providingSource() {
            return
        }
        
        self.lastPowerStatus = PowerStatus.sharedInstance().providingSource()
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
        
        self.resetHUDTimer(&self.powerStatusHUD) {
            withAnimation {
                self.powerStatusHUD = nil
            }
        }
    }
    
    @objc func handleNowPlayingMediaChanges() {
        
        if !NowPlaying.sharedInstance().playing {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                if NowPlaying.sharedInstance().playing {
                    return
                }
                
                withAnimation {
                    self.nowPlayingMedia = nil
                }
            }
        }
        
        guard let appBundleIdentifier = NowPlaying.sharedInstance().appBundleIdentifier,
              let appName = NowPlaying.sharedInstance().appName,
              let appIcon = NowPlaying.sharedInstance().appIcon,
              let albumArt = NowPlaying.sharedInstance().albumArt,
              let album = NowPlaying.sharedInstance().album,
              let artist = NowPlaying.sharedInstance().artist,
              let title = NowPlaying.sharedInstance().title,
              let elapsedTime = NowPlaying.sharedInstance().elapsedTime,
              let totalDuration = NowPlaying.sharedInstance().totalDuration,
              let playbackRate = NowPlaying.sharedInstance().playbackRate,
              let refreshedAt = NowPlaying.sharedInstance().refreshedAt else {
            return
        }
        
        withAnimation {
            nowPlayingMedia = .init(
                appBundleIdentifier: appBundleIdentifier,
                appName: appName,
                appIcon: .init(
                    nsImage: appIcon
                ),
                albumArt: .init(
                    nsImage: albumArt
                ),
                album: album,
                artist: artist,
                title: title,
                elapsedTime: elapsedTime.doubleValue,
                totalDuration: totalDuration.doubleValue,
                playbackRate: playbackRate.doubleValue,
                isPlaying: NowPlaying.sharedInstance().playing,
                refreshedAt: refreshedAt
            )
        }
    }
}
