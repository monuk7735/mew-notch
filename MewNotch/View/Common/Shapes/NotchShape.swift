//
//  NotchShape.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

struct NotchShape: Shape {
    var topRadius: CGFloat
    var bottomRadius: CGFloat

    init(
        topRadius: CGFloat = 8,
        bottomRadius: CGFloat = 13
    ) {
        self.bottomRadius = bottomRadius
        self.topRadius = topRadius
    }

    var animatableData: CGFloat {
        get { bottomRadius }
        set { bottomRadius = newValue }
    }

    func path(
        in rect: CGRect
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX + topRadius,
                y: rect.minY + topRadius
            ),
            control: CGPoint(
                x: rect.minX + topRadius,
                y: rect.minY
            )
        )

        path
            .addLine(
                to: CGPoint(
                    x: rect.minX + topRadius,
                    y: rect.maxY - bottomRadius
                )
            )

        path
            .addQuadCurve(
                to: CGPoint(
                    x: rect.minX + topRadius + bottomRadius,
                    y: rect.maxY
                ),
                control: CGPoint(
                    x: rect.minX + topRadius,
                    y: rect.maxY
                )
            )

        path
            .addLine(
                to: CGPoint(
                    x: rect.maxX - topRadius - bottomRadius,
                    y: rect.maxY
                )
            )

        path
            .addQuadCurve(
                to: CGPoint(
                    x: rect.maxX - topRadius,
                    y: rect.maxY - bottomRadius
                ),
                control: CGPoint(
                    x: rect.maxX - topRadius,
                    y: rect.maxY
                )
            )

        path
            .addLine(
                to: CGPoint(
                    x: rect.maxX - topRadius,
                    y: rect.minY + bottomRadius
                )
            )

        path
            .addQuadCurve(
                to: CGPoint(
                    x: rect.maxX,
                    y: rect.minY
                ),
                control: CGPoint(
                    x: rect.maxX - topRadius,
                    y: rect.minY
                )
            )

        path
            .addLine(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.minY
                )
            )

        return path
    }
}

struct AdaptiveNotchShape: Shape {
    var isHardwareNotched: Bool
    var topRadius: CGFloat
    var bottomRadius: CGFloat
    var floatingCornerRadius: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(bottomRadius, floatingCornerRadius)
        }
        set {
            bottomRadius = newValue.first
            floatingCornerRadius = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        if isHardwareNotched {
            NotchShape(
                topRadius: topRadius,
                bottomRadius: bottomRadius
            ).path(in: rect)
        } else {
            RoundedRectangle(
                cornerRadius: floatingCornerRadius,
                style: .continuous
            ).path(in: rect)
        }
    }
}
