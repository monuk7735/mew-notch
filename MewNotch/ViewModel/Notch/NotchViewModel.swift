//
//  NotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class NotchViewModel: ObservableObject {
    var screen: NSScreen
    @Published var isHardwareNotched: Bool = false

    @Published var notchSize: CGSize = .zero
    var baseNotchSize: CGSize = .zero

    @Published var cornerRadius: (
        top: CGFloat,
        bottom: CGFloat
    ) = (
        top: 8,
        bottom: 13
    )

    var minimalHUDPadding: CGFloat = 0

    var extraNotchPadSize: CGSize = .init(
        width: 16,
        height: 0
    )

    @Published var isDropTarget: Bool = false
    @Published var isHovered: Bool = false
    @Published var isExpanded: Bool = false
    @Published var isPinned: Bool = false

    private var hoverTimer: Timer?

    init(
        screen: NSScreen
    ) {
        self.screen = screen
        isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)
        cornerRadius = isHardwareNotched
            ? NotchUtils.shared.collapsedCornerRadius
            : NotchUtils.shared.unnotchedCollapsedCornerRadius

        refreshNotchSize()
    }

    func refreshNotchSize() {
        isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)
        let shouldForce = NotchDefaults.shared.notchDisplayVisibility != .notchedDisplayOnly

        var calculated = NotchUtils.shared.notchSize(
            screen: screen,
            force: shouldForce
        )
        calculated.width += extraNotchPadSize.width
        calculated.height += extraNotchPadSize.height

        baseNotchSize = calculated
        notchSize = calculated
        minimalHUDPadding = calculated.height * 0.2
    }

    func onHover(
        _ isHovered: Bool,
        shouldExpand: Bool = true
    ) {
        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(
                pattern: .generic
            )
        }

        hoverTimer?.invalidate()

        if isHovered {
            if shouldExpand {
                hoverTimer = .scheduledTimer(
                    withTimeInterval: NotchDefaults.shared.expandOnHoverDelay,
                    repeats: false
                ) { _ in
                    if NotchDefaults.shared.hapticFeedback {
                        HapticsManager.shared.feedback(
                            pattern: .generic
                        )
                    }

                    self.onTap()
                }
            }
        } else if !isPinned {
            withAnimation {
                self.isExpanded = false

                self.cornerRadius = self.isHardwareNotched
                    ? NotchUtils.shared.collapsedCornerRadius
                    : NotchUtils.shared.unnotchedCollapsedCornerRadius
                self.extraNotchPadSize = .init(
                    width: self.cornerRadius.top * 2,
                    height: 0
                )
            }
        }

        withAnimation {
            self.isHovered = isHovered
        }
    }

    func onTap() {
        withAnimation(
            .spring(
                .bouncy(
                    duration: 0.4,
                    extraBounce: 0.1
                )
            )
        ) {
            self.isExpanded = true
        }

        withAnimation {
            self.cornerRadius = self.isHardwareNotched
                ? NotchUtils.shared.expandedCornerRadius
                : NotchUtils.shared.unnotchedExpandedCornerRadius
            self.extraNotchPadSize = .init(
                width: self.cornerRadius.top * 2,
                height: 0
            )
        }
    }
}
