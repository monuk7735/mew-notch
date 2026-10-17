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

    @Published var isDropTarget: Bool = false {
        didSet {
            updateEffectiveNotchState()
        }
    }

    @Published var isHovered: Bool = false {
        didSet {
            updateEffectiveNotchState()
        }
    }

    @Published var isExpanded: Bool = false {
        didSet {
            updateEffectiveNotchState()
        }
    }

    @Published var hasActiveHUD: Bool = false {
        didSet {
            updateEffectiveNotchState()
        }
    }

    @Published var isPinned: Bool = false

    var isThinBulge: Bool {
        guard !isHardwareNotched else { return false }
        return !isHovered && !isExpanded && !hasActiveHUD && !isDropTarget
    }

    private var hoverTimer: Timer?

    init(
        screen: NSScreen
    ) {
        self.screen = screen
        isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)

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

        if !isHardwareNotched {
            updateEffectiveNotchState()
        }
    }

    func updateEffectiveNotchState() {
        guard !isHardwareNotched else { return }

        let isThin = isThinBulge
        let targetHeight: CGFloat = isThin ? 8.0 : baseNotchSize.height
        let targetCornerRadius: (top: CGFloat, bottom: CGFloat) = isThin
            ? (top: 8.0, bottom: 4.0)
            : (isExpanded ? NotchUtils.shared.expandedCornerRadius : NotchUtils.shared.collapsedCornerRadius)

        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.notchSize.height = targetHeight
            self.cornerRadius = targetCornerRadius
        }
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
            withAnimation {
                self.isExpanded = false

                if self.isHardwareNotched {
                    self.cornerRadius = NotchUtils.shared.collapsedCornerRadius
                } else {
                    self.cornerRadius = self.isThinBulge ? (top: 8.0, bottom: 4.0) : NotchUtils.shared.collapsedCornerRadius
                }
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
            self.cornerRadius = NotchUtils.shared.expandedCornerRadius
            self.extraNotchPadSize = .init(
                width: self.cornerRadius.top * 2,
                height: 0
            )
        }
    }
}
