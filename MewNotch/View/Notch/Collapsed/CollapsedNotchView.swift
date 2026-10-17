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

    @StateObject var collapsedNotchViewModel: CollapsedNotchViewModel
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var mediaDefaults = HUDMediaDefaults.shared

    init(
        namespace: Namespace.ID,
        notchViewModel: NotchViewModel
    ) {
        self.namespace = namespace
        self.notchViewModel = notchViewModel
        _collapsedNotchViewModel = StateObject(wrappedValue: CollapsedNotchViewModel(screen: notchViewModel.screen))
    }

    var body: some View {
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
                    notchSize: notchViewModel.notchSize
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
        .opacity(notchViewModel.isThinBulge ? 0 : 1)
        .animation(.easeInOut(duration: 0.2), value: notchViewModel.isThinBulge)
        .onAppear {
            notchViewModel.hasActiveHUD = collapsedNotchViewModel.hasActiveHUD
        }
        .onChange(of: collapsedNotchViewModel.hasActiveHUD) { _, newValue in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                notchViewModel.hasActiveHUD = newValue
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
}
