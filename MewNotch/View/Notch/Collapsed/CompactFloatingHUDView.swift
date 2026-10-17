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
    @StateObject private var notchDefaults = NotchDefaults.shared

    private var hudHeight: CGFloat {
        max(24, min(30, notchViewModel.notchSize.height))
    }

    var body: some View {
        VStack(spacing: 8) {
            if let brightness = collapsedNotchViewModel.brightnessHUD,
               HUDBrightnessDefaults.shared.isEnabled {
                CompactSliderHUDView(
                    hud: brightness,
                    style: HUDBrightnessDefaults.shared.style,
                    animateChanges: HUDBrightnessDefaults.shared.animateChanges,
                    height: hudHeight,
                    applyGlassEffect: notchDefaults.applyGlassEffect
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if let lock = collapsedNotchViewModel.lockStatusHUD {
                CompactLockHUDView(
                    notchViewModel: notchViewModel,
                    hud: lock,
                    height: hudHeight,
                    applyGlassEffect: notchDefaults.applyGlassEffect
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.top, 8)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: collapsedNotchViewModel.brightnessHUD != nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: collapsedNotchViewModel.lockStatusHUD != nil)
    }
}

struct CompactSliderHUDView: View {
    var hud: HUDPropertyModel
    var style: HUDStyle
    var animateChanges: Bool = true
    var height: CGFloat
    var applyGlassEffect: Bool

    var body: some View {
        HStack(spacing: 6) {
            hud.getIcon()
                .frame(width: 16, height: 16)

            if style != .minimal {
                GeometryReader { barGeometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.18))
                            .frame(height: 4)

                        Capsule()
                            .fill(Color.accentColor)
                            .frame(
                                width: max(4, CGFloat(hud.value) * barGeometry.size.width),
                                height: 4
                            )
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .frame(width: 60, height: 14)
            }

            AnimatedTextView(value: Double(hud.value * 100)) { value in
                Text(String(format: "%02.0f", value))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .monospacedDigit()
                    .fixedSize(horizontal: true, vertical: false)
            }
            .if(!animateChanges) { view in
                view.animation(nil, value: hud.value)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: height)
        .glassEffect(when: applyGlassEffect, in: Capsule())
        .background {
            if !applyGlassEffect {
                Color.black
            }
        }
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct CompactLockHUDView: View {
    @ObservedObject var notchViewModel: NotchViewModel
    var hud: HUDPropertyModel
    var height: CGFloat
    var applyGlassEffect: Bool

    @State private var progress: CGFloat = 0

    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.white)
                .mask {
                    LottieView(
                        animation: AppAnimation.lock
                    )
                    .currentProgress(1 - progress)
                    .scaleEffect(1.2)
                }
                .frame(
                    width: 16,
                    height: 16
                )

            Text(hud.name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 10)
        .frame(height: height)
        .glassEffect(when: applyGlassEffect, in: Capsule())
        .background {
            if !applyGlassEffect {
                Color.black
            }
        }
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        .onAppear {
            progress = CGFloat(hud.value)
        }
        .onChange(of: hud.value) { _, newValue in
            animateTo(CGFloat(newValue))
        }
    }

    private func animateTo(_ newValue: CGFloat) {
        let duration = 0.3
        let steps = 30
        let stepTime = duration / Double(steps)
        let start = progress
        let delta = newValue - start

        for step in 0 ... steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(step)) {
                let progress = start + delta * CGFloat(step) / CGFloat(steps)
                self.progress = progress
            }
        }
    }
}
