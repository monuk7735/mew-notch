//
//  CompactFloatingHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import Lottie
import SwiftUI

struct CompactFloatingHUDView: View {
    var namespace: Namespace.ID
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var collapsedNotchViewModel: CollapsedNotchViewModel
    @StateObject var mediaDefaults = HUDMediaDefaults.shared

    var body: some View {
        HStack(spacing: 8) {
            contentView
        }
        .frame(height: max(28, notchViewModel.notchSize.height))
    }

    @ViewBuilder
    private var contentView: some View {
        if let brightness = collapsedNotchViewModel.brightnessHUD,
           HUDBrightnessDefaults.shared.isEnabled {
            CompactSliderHUDView(
                hud: brightness,
                style: HUDBrightnessDefaults.shared.style,
                animateChanges: HUDBrightnessDefaults.shared.animateChanges
            )
        } else if let volume = collapsedNotchViewModel.outputAudioVolumeHUD,
                  HUDAudioOutputDefaults.shared.isEnabled {
            CompactSliderHUDView(
                hud: volume,
                style: HUDAudioOutputDefaults.shared.style,
                animateChanges: HUDAudioOutputDefaults.shared.animateChanges
            )
        } else if let inputVolume = collapsedNotchViewModel.inputAudioVolumeHUD,
                  HUDAudioInputDefaults.shared.isEnabled {
            CompactSliderHUDView(
                hud: inputVolume,
                style: HUDAudioInputDefaults.shared.style,
                animateChanges: HUDAudioInputDefaults.shared.animateChanges
            )
        } else if let power = collapsedNotchViewModel.powerStatusHUD,
                  HUDPowerDefaults.shared.showTimeRemaining {
            CompactPowerHUDView(hud: power)
        } else if let device = collapsedNotchViewModel.outputAudioDeviceHUD {
            CompactAudioDeviceHUDView(deviceName: device.name, isInput: false)
        } else if let device = collapsedNotchViewModel.inputAudioDeviceHUD {
            CompactAudioDeviceHUDView(deviceName: device.name, isInput: true)
        } else if let lock = collapsedNotchViewModel.lockStatusHUD {
            CompactLockHUDView(hud: lock)
        } else if let track = collapsedNotchViewModel.nowPlayingChangesHUD {
            CompactTrackHUDView(title: track.name)
        } else if mediaDefaults.isEnabled, collapsedNotchViewModel.nowPlayingMedia != nil {
            CompactNowPlayingHUDView(
                namespace: namespace,
                notchViewModel: notchViewModel,
                collapsedNotchViewModel: collapsedNotchViewModel
            )
        } else {
            OnlyNotchView(
                notchSize: notchViewModel.notchSize,
                isHardwareNotched: false,
                hasActiveContent: false
            )
        }
    }
}

struct CompactSliderHUDView: View {
    var hud: HUDPropertyModel
    var style: HUDStyle
    var animateChanges: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            hud.getIcon()
                .frame(width: 16, height: 16)

            if style != .minimal {
                GeometryReader { barGeometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.18))
                            .frame(height: 5)

                        Capsule()
                            .fill(Color.accentColor)
                            .frame(
                                width: max(5, CGFloat(hud.value) * barGeometry.size.width),
                                height: 5
                            )
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .frame(width: 72, height: 16)
            }

            AnimatedTextView(value: Double(hud.value * 100)) { value in
                Text(String(format: "%02.0f%%", value))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .monospacedDigit()
                    .fixedSize(horizontal: true, vertical: false)
            }
            .if(!animateChanges) { view in
                view.animation(nil, value: hud.value)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct CompactPowerHUDView: View {
    var hud: HUDPropertyModel

    var body: some View {
        HStack(spacing: 8) {
            hud.getIcon()
                .frame(width: 18, height: 18)

            if hud.value.isFinite {
                let formatted = hud.value.formattedDuration(allowedUnits: [.hours, .minutes], width: .narrow)
                Text("\(formatted) Left")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
                    .fixedSize(horizontal: true, vertical: false)
            } else {
                Text(hud.name)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct CompactAudioDeviceHUDView: View {
    var deviceName: String
    var isInput: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isInput ? "mic.fill" : "headphones")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.accentColor)

            Text(deviceName)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 12)
    }
}

struct CompactLockHUDView: View {
    var hud: HUDPropertyModel

    var body: some View {
        HStack(spacing: 8) {
            hud.getIcon()
                .frame(width: 16, height: 16)

            Text(hud.name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 12)
    }
}

struct CompactTrackHUDView: View {
    var title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "music.note")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: 200, alignment: .leading)
        }
        .padding(.horizontal, 12)
    }
}

struct CompactNowPlayingHUDView: View {
    var namespace: Namespace.ID
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var collapsedNotchViewModel: CollapsedNotchViewModel

    var body: some View {
        HStack(spacing: 8) {
            NowPlayingHUDLeftView(
                namespace: namespace,
                notchViewModel: notchViewModel,
                nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
            )

            NowPlayingHUDRightView(
                notchViewModel: notchViewModel,
                nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
            )
        }
        .padding(.horizontal, 8)
    }
}
