//
//  ScreenLockHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/06/25.
//

import SwiftUI
import Lottie

struct ScreenLockHUDView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var hudModel: HUDPropertyModel?
    
    @State var progress: CGFloat = 0
    
    var body: some View {
        if let hud = hudModel {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .left
            ) {
                TimelineView(.animation) { context in
                    Rectangle()
                        .mask {
                            LottieView(
                                animation: MewNotch.Lotties.lock
                            )
                            .currentProgress(1 - progress)
                            .scaleEffect(1.2)
                        }
                }
            }
            .onAppear {
                progress = CGFloat(hud.value)
            }
            .onChange(
                of: hud.value
            ) { _, newValue in
                animateTo(CGFloat(newValue))
            }
        }
    }
    
    private func animateTo(_ newValue: CGFloat) {
        // Smoothly interpolate animatedProgress to newValue
        let duration = 0.3
        let steps = 30
        let stepTime = duration / Double(steps)
        let start = progress
        let delta = newValue - start
        
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(step)) {
                let progress = start + delta * CGFloat(step) / CGFloat(steps)
                self.progress = progress
            }
        }
    }
}
