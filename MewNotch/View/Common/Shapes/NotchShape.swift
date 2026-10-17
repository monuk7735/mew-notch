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

        let radiusY = max(0, min(topRadius, rect.height * 0.45))
        let radiusX = max(0, min(topRadius * 1.2, rect.width / 4))
        let clampedBottomRadius = max(0, min(bottomRadius, min((rect.width - radiusX * 2) * 0.5, rect.height - radiusY)))

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        addLeftContour(to: &path, in: rect, radiusX: radiusX, radiusY: radiusY, bottomRadius: clampedBottomRadius)
        addRightContour(to: &path, in: rect, radiusX: radiusX, radiusY: radiusY, bottomRadius: clampedBottomRadius)

        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        return path
    }

    private func addLeftContour(
        to path: inout Path,
        in rect: CGRect,
        radiusX: CGFloat,
        radiusY: CGFloat,
        bottomRadius: CGFloat
    ) {
        path.addCurve(
            to: CGPoint(
                x: rect.minX + radiusX,
                y: rect.minY + radiusY
            ),
            control1: CGPoint(
                x: rect.minX + radiusX * 0.5,
                y: rect.minY
            ),
            control2: CGPoint(
                x: rect.minX + radiusX,
                y: rect.minY + radiusY * 0.5
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX + radiusX,
                y: rect.maxY - bottomRadius
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.minX + radiusX + bottomRadius,
                y: rect.maxY
            ),
            control1: CGPoint(
                x: rect.minX + radiusX,
                y: rect.maxY - bottomRadius * 0.448
            ),
            control2: CGPoint(
                x: rect.minX + radiusX + bottomRadius * 0.448,
                y: rect.maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX - radiusX - bottomRadius,
                y: rect.maxY
            )
        )
    }

    private func addRightContour(
        to path: inout Path,
        in rect: CGRect,
        radiusX: CGFloat,
        radiusY: CGFloat,
        bottomRadius: CGFloat
    ) {
        path.addCurve(
            to: CGPoint(
                x: rect.maxX - radiusX,
                y: rect.maxY - bottomRadius
            ),
            control1: CGPoint(
                x: rect.maxX - radiusX - bottomRadius * 0.448,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.maxX - radiusX,
                y: rect.maxY - bottomRadius * 0.448
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX - radiusX,
                y: rect.minY + radiusY
            )
        )

        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            control1: CGPoint(
                x: rect.maxX - radiusX,
                y: rect.minY + radiusY * 0.5
            ),
            control2: CGPoint(
                x: rect.maxX - radiusX * 0.5,
                y: rect.minY
            )
        )
    }
}
