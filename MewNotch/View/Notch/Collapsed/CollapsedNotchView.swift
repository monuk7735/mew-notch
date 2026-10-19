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
    var floatingIdleHeight: CGFloat?
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var mediaDefaults = HUDMediaDefaults.shared

    var body: some View {
        hardwareCollapsedNotchView
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
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowBrightnessHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioInputHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioOutputHUD
                )

                ScreenLockHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: collapsedNotchViewModel.lockStatusHUD
                )
                .hide(
                    when: !notchDefaults.lockScreenShowLockStatusHUD
                )

                NowPlayingHUDLeftView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled || (collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowMediaHUD)
                )
                .hide(
                    when: notchViewModel.isExpanded
                )

                OnlyNotchView(
                    notchSize: notchViewModel.notchSize,
                    height: (!collapsedNotchViewModel.hasActiveContent && !notchViewModel.isExpanded) ? floatingIdleHeight : nil
                )

                NowPlayingHUDRightView(
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled || (collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowMediaHUD)
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
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioOutputHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioInputHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )
                .hide(
                    when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowBrightnessHUD
                )
            }
            .padding(.horizontal, 0)

            PowerHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDPowerDefaults.shared,
                hudModel: collapsedNotchViewModel.powerStatusHUD
            )
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowPowerHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .input,
                hudModel: collapsedNotchViewModel.inputAudioDeviceHUD
            )
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioInputHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .output,
                hudModel: collapsedNotchViewModel.outputAudioDeviceHUD
            )
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioOutputHUD
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
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowBrightnessHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioInputHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )
            .hide(
                when: collapsedNotchViewModel.isCurrentlyLocked && !notchDefaults.lockScreenShowAudioOutputHUD
            )
        }
    }
}
