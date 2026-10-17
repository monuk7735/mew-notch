//
//  LiquidMeltView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct LiquidMeltContainer<Content: View>: View, Animatable {
    var progress: CGFloat // 0.0 = melted into top edge, 1.0 = floating
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var isHardwareNotched: Bool
    var applyGlassEffect: Bool
    var hardwareShape: AdaptiveNotchShape
    @ViewBuilder var content: Content

    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(progress, AnimatablePair(width, height))
        }
        set {
            progress = newValue.first
            width = newValue.second.first
            height = newValue.second.second
        }
    }

    var body: some View {
        if isHardwareNotched {
            hardwareNotchBody
        } else {
            floatingMeltBody
        }
    }

    private var hardwareNotchBody: some View {
        content
            .glassEffect(when: applyGlassEffect, in: hardwareShape)
            .background {
                if !applyGlassEffect {
                    Color.black
                }
            }
            .mask {
                hardwareShape
            }
            .contentShape(hardwareShape)
    }

    private var floatingMeltBody: some View {
        let clampedProgress = max(0, min(1, progress))

        return Group {
            if clampedProgress <= 0.005 {
                Color.clear
                    .frame(width: max(1, width), height: max(1, height))
            } else {
                let floatingY: CGFloat = 8.0
                let retractedY: CGFloat = -(height + 15.0)
                let currentY = retractedY + (floatingY - retractedY) * clampedProgress

                let canvasWidth = max(width + 80, 200)
                let canvasHeight = max(height + 40, 80)

                let contentOpacity = max(0, min(1, (clampedProgress - 0.25) / 0.7))
                let borderOpacity = max(0, min(1, (clampedProgress - 0.92) / 0.08))

                ZStack(alignment: .top) {
                    liquidBackground(
                        canvasWidth: canvasWidth,
                        canvasHeight: canvasHeight,
                        currentY: currentY,
                        progress: clampedProgress
                    )

                    if !applyGlassEffect, borderOpacity > 0.01 {
                        floatingBorder(currentY: currentY, borderOpacity: borderOpacity)
                    }

                    notchForeground(currentY: currentY, contentOpacity: contentOpacity)
                }
                .frame(width: canvasWidth, height: canvasHeight, alignment: .top)
                .allowsHitTesting(clampedProgress > 0.8)
            }
        }
    }

    private func liquidBackground(
        canvasWidth: CGFloat,
        canvasHeight: CGFloat,
        currentY: CGFloat,
        progress: CGFloat
    ) -> some View {
        ZStack(alignment: .top) {
            if applyGlassEffect {
                Rectangle()
                    .glassEffect(when: true, in: Rectangle())
                    .frame(width: canvasWidth, height: canvasHeight)
            } else {
                Color.black
                    .frame(width: canvasWidth, height: canvasHeight)
            }
        }
        .mask {
            LiquidMeltCanvas(
                progress: progress,
                width: max(1, width),
                height: max(1, height),
                cornerRadius: cornerRadius,
                currentY: currentY
            )
            .frame(width: canvasWidth, height: canvasHeight)
        }
    }

    private func floatingBorder(currentY: CGFloat, borderOpacity: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(Color.white.opacity(0.12 * borderOpacity), lineWidth: 0.5)
            .frame(width: width, height: height)
            .offset(y: currentY)
    }

    private func notchForeground(currentY: CGFloat, contentOpacity: CGFloat) -> some View {
        content
            .frame(width: width, height: height)
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            }
            .offset(y: currentY)
            .opacity(contentOpacity)
    }
}

private struct LiquidMeltCanvas: View {
    var progress: CGFloat
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var currentY: CGFloat

    var body: some View {
        Canvas { context, size in
            guard progress > 0.01 else { return }

            let centerX = size.width / 2

            applyFilters(to: &context)

            context.drawLayer { ctx in
                drawCeilingAnchor(in: &ctx, size: size, centerX: centerX)
                drawCapsule(in: &ctx, centerX: centerX)
            }
        }
    }

    private func applyFilters(to context: inout GraphicsContext) {
        let blurRadius: CGFloat
        if progress >= 0.95 {
            let ratio = (1.0 - progress) / 0.05
            blurRadius = 12.0 * ratio
        } else if progress <= 0.15 {
            let ratio = progress / 0.15
            blurRadius = max(3.0, 12.0 * ratio)
        } else {
            blurRadius = 12.0
        }

        if blurRadius > 0.5 {
            context.addFilter(.alphaThreshold(min: 0.5, color: .white))
            context.addFilter(.blur(radius: blurRadius))
        }
    }

    private func drawCeilingAnchor(in ctx: inout GraphicsContext, size: CGSize, centerX: CGFloat) {
        guard progress < 0.92 else { return }

        let normalized = progress / 0.92
        let bulge = sin(normalized * .pi)
        let anchorHeight = max(2.0, 4.0 + bulge * 8.0)
        let anchorWidth = min(width * (0.6 + 0.4 * bulge), size.width)

        let anchorRect = CGRect(
            x: centerX - anchorWidth / 2,
            y: 0,
            width: anchorWidth,
            height: anchorHeight
        )
        ctx.fill(Path(anchorRect), with: .color(.white))
    }

    private func drawCapsule(in ctx: inout GraphicsContext, centerX: CGFloat) {
        let capsuleRect = CGRect(
            x: centerX - width / 2,
            y: currentY,
            width: width,
            height: height
        )

        let capsulePath = Path(
            roundedRect: capsuleRect,
            cornerRadius: cornerRadius,
            style: .continuous
        )
        ctx.fill(capsulePath, with: .color(.white))
    }
}
