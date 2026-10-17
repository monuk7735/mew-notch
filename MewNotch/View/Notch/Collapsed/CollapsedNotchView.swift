//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Lottie
import SwiftUI

struct CollapsedNotchView: View {
    var namespace: Namespace.ID
    @ObservedObject var notchViewModel: NotchViewModel

    @ObservedObject var collapsedNotchViewModel: CollapsedNotchViewModel
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var mediaDefaults = HUDMediaDefaults.shared

    var body: some View {
        Group {
            if notchViewModel.isHardwareNotched {
                hardwareCollapsedNotchView
            } else {
                CompactFloatingHUDView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    collapsedNotchViewModel: collapsedNotchViewModel
                )
            }
        }
        .onReceive(
            notchDefaults.objectWillChange
        ) {
            collapsedNotchViewModel.hideHUDs()

            DispatchQueue.main.async {
                notchViewModel.refreshNotchSize()
            }
        }
    }

    private var hardwareCollapsedNotchView: some View {
        VStack(
            spacing: 0
        ) {
            HStack(
                spacing: 0
            ) {
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )

                ScreenLockHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: collapsedNotchViewModel.lockStatusHUD
                )

                NowPlayingHUDLeftView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                .hide(
                    when: notchViewModel.isExpanded
                )

                OnlyNotchView(
                    notchSize: notchViewModel.notchSize,
                    isHardwareNotched: notchViewModel.isHardwareNotched,
                    hasActiveContent: collapsedNotchViewModel.hasActiveContent
                )

                NowPlayingHUDRightView(
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                .hide(
                    when: notchViewModel.isExpanded
                )

                MinimalHUDView(
                    notchViewModel: notchViewModel,
                    variant: .right
                ) {
                    Text("")
                }
                .hide(
                    when: collapsedNotchViewModel.lockStatusHUD == nil
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )
            }
            .padding(.horizontal, notchViewModel.isHardwareNotched ? 0 : 10)

            PowerHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDPowerDefaults.shared,
                hudModel: collapsedNotchViewModel.powerStatusHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .input,
                hudModel: collapsedNotchViewModel.inputAudioDeviceHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .output,
                hudModel: collapsedNotchViewModel.outputAudioDeviceHUD
            )

            NowPlayingTextHUDView(
                notchViewModel: notchViewModel,
                hudModel: collapsedNotchViewModel.nowPlayingChangesHUD
            )
            .hide(
                when: notchViewModel.isExpanded
            )

            // MARK: Progress Style Views

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )

            // MARK: Notched Style View

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )
        }
    }
}
