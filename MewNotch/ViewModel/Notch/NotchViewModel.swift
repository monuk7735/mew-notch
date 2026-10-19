//
//  NotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class NotchViewModel: ObservableObject {
    var screen: NSScreen

    @Published var notchSize: CGSize = .zero
    @Published var isHardwareNotched: Bool = true

    var cornerRadius: (
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
    @Published var isMenuOpen: Bool = false
    @Published var isRenaming: Bool = false

    private var hoverTimer: Timer?

    init(
        screen: NSScreen
    ) {
        self.screen = screen
        refreshNotchSize()
        startTrackingObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func startTrackingObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMenuDidBeginTracking),
            name: NSMenu.didBeginTrackingNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMenuDidEndTracking),
            name: NSMenu.didEndTrackingNotification,
            object: nil
        )
    }

    @objc private func handleMenuDidBeginTracking() {
        DispatchQueue.main.async {
            self.isMenuOpen = true
        }
    }

    @objc private func handleMenuDidEndTracking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self else { return }
            isMenuOpen = false
            if !isHovered, !isPinned, !isRenaming {
                collapse()
            }
        }
    }

    private var isSimulatedNotch: Bool {
        !isHardwareNotched && NotchDefaults.shared.externalNotchStyle == .simulatedNotch
    }

    private var extraPadWidth: CGFloat {
        if isHardwareNotched || isSimulatedNotch {
            return cornerRadius.top * 2
        } else {
            return 0
        }
    }

    func refreshNotchSize() {
        isHardwareNotched = NotchUtils.shared.hasNotch(screen: screen)
        let isExternalPersistent = !isHardwareNotched &&
            (NotchDefaults.shared.externalNotchStyle == .floatingIsland ||
             NotchDefaults.shared.externalNotchStyle == .simulatedNotch)
        let shouldForce = NotchDefaults.shared.notchDisplayVisibility != .notchedDisplayOnly || isExternalPersistent

        extraNotchPadSize = .init(
            width: extraPadWidth,
            height: 0
        )

        notchSize = NotchUtils.shared.notchSize(
            screen: screen,
            force: shouldForce
        )

        if !isHardwareNotched && NotchDefaults.shared.externalNotchStyle == .floatingIsland {
            notchSize.width = CGFloat(NotchDefaults.shared.floatingIslandWidth)
            notchSize.height += CGFloat(NotchDefaults.shared.floatingIslandHeightOffset)
        }

        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height

            minimalHUDPadding = notchSize.height * 0.2
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

        withAnimation {
            self.isHovered = isHovered
        }

        if isHovered {
            if shouldExpand {
                hoverTimer = .scheduledTimer(
                    withTimeInterval: NotchDefaults.shared.expandOnHoverDelay,
                    repeats: false
                ) { [weak self] _ in
                    guard let self else { return }
                    if NotchDefaults.shared.hapticFeedback {
                        HapticsManager.shared.feedback(
                            pattern: .generic
                        )
                    }

                    onTap()
                }
            }
        } else if !isPinned, !isMenuOpen, !isRenaming {
            collapse()
        }
    }

    func collapse() {
        guard !isPinned, !isMenuOpen, !isRenaming else { return }
        withAnimation {
            self.isExpanded = false

            self.cornerRadius = NotchUtils.shared.collapsedCornerRadius
            self.extraNotchPadSize = .init(
                width: self.extraPadWidth,
                height: 0
            )
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
                width: self.extraPadWidth,
                height: 0
            )
        }
    }
}
