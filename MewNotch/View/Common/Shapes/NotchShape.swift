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

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(topRadius, bottomRadius) }
        set {
            topRadius = newValue.first
            bottomRadius = newValue.second
        }
    }

    func path(
        in rect: CGRect
    ) -> Path {
        var path = Path()

        let rY = max(0, min(topRadius, rect.height * 0.45))
        let rX = max(0, min(topRadius * 1.2, rect.width / 4))
        let bRad = max(0, min(bottomRadius, min((rect.width - rX * 2) * 0.5, rect.height - rY)))

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        // Smooth cubic melt curve from top border down to notch side
        path.addCurve(
            to: CGPoint(
                x: rect.minX + rX,
                y: rect.minY + rY
            ),
            control1: CGPoint(
                x: rect.minX + rX * 0.5,
                y: rect.minY
            ),
            control2: CGPoint(
                x: rect.minX + rX,
                y: rect.minY + rY * 0.5
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX + rX,
                y: rect.maxY - bRad
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.minX + rX + bRad,
                y: rect.maxY
            ),
            control1: CGPoint(
                x: rect.minX + rX,
                y: rect.maxY - bRad * 0.5
            ),
            control2: CGPoint(
                x: rect.minX + rX + bRad * 0.5,
                y: rect.maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX - rX - bRad,
                y: rect.maxY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.maxX - rX,
                y: rect.maxY - bRad
            ),
            control1: CGPoint(
                x: rect.maxX - rX - bRad * 0.5,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.maxX - rX,
                y: rect.maxY - bRad * 0.5
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX - rX,
                y: rect.minY + rY
            )
        )

        // Smooth cubic melt curve back up to top border
        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            control1: CGPoint(
                x: rect.maxX - rX,
                y: rect.minY + rY * 0.5
            ),
            control2: CGPoint(
                x: rect.maxX - rX * 0.5,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        return path
    }
}
