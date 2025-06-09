//
//  NowPlayingHUDRightView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

import Lottie

struct NowPlayingHUDRightView: View {
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var nowPlayingModel: NowPlayingMediaModel?
    
    @State private var isHovered: Bool = false
    
    var body: some View {
        if let nowPlayingModel {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .right
            ) {
                LottieView(
                    animation: MewNotch.Lotties.visualizer
                )
                .animationSpeed(0.2)
                .playbackMode(
                    nowPlayingModel.isPlaying
                    ? .playing(
                        .fromProgress(
                            0,
                            toProgress: 1,
                            loopMode: .loop
                        )
                    )
                    : .paused
                )
                .scaledToFit()
                .opacity(self.isHovered ? 0 : 1)
                .overlay {
                    if self.isHovered {
                        Button(
                            action: {
                                MediaController.sharedInstance().togglePlayPause()
                            }
                        ) {
                            Image(
                                systemName: nowPlayingModel.isPlaying ? "pause.fill" : "play.fill"
                            )
                            .resizable()
                            .scaledToFit()
                        }
                        .buttonStyle(.plain)
                        .padding(6)
                    }
                }
            }
            .onHover { isHovered in
                withAnimation {
                    self.isHovered = isHovered && !notchDefaults.expandOnHover
                }
            }
        }
    }
}
