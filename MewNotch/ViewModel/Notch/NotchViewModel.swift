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
    private var globalMouseMonitor: Any?
    private var localMouseMonitor: Any?
    private var mouseTrackingTimer: Timer?
    private var expansionDate: Date?
    var notchScreenRect: CGRect = .zero

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

    deinit {
        stopMouseTracking()
        hoverTimer?.invalidate()
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

    func updateNotchFrame(_ rect: CGRect) {
        guard rect.width > 0, rect.height > 0 else { return }
        let screenFrame = screen.frame
        let minX = screenFrame.minX + rect.minX
        let minY = screenFrame.maxY - rect.maxY
        notchScreenRect = CGRect(
            x: minX,
            y: minY,
            width: rect.width,
            height: rect.height
        )
    }

    func startMouseTracking() {
        stopMouseTracking()
        expansionDate = Date()

        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved]
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkMousePosition()
            }
        }

        localMouseMonitor = NSEvent.addLocalMonitorForEvents(
            matching: [.mouseMoved]
        ) { [weak self] event in
            self?.checkMousePosition()
            return event
        }

        mouseTrackingTimer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true
        ) { [weak self] _ in
            self?.checkMousePosition()
        }
    }

    func stopMouseTracking() {
        if let monitor = globalMouseMonitor {
            NSEvent.removeMonitor(monitor)
            globalMouseMonitor = nil
        }
        if let monitor = localMouseMonitor {
            NSEvent.removeMonitor(monitor)
            localMouseMonitor = nil
        }
        mouseTrackingTimer?.invalidate()
        mouseTrackingTimer = nil
    }

    func checkMousePosition() {
        guard isExpanded, !isPinned, !isDropTarget else { return }

        if let expansionDate, Date().timeIntervalSince(expansionDate) < 0.2 {
            return
        }

        guard notchScreenRect.width > 0, notchScreenRect.height > 0 else { return }

        let mouseLoc = NSEvent.mouseLocation
        let activeRect = notchScreenRect.insetBy(dx: -8, dy: -8)

        if !activeRect.contains(mouseLoc) {
            collapse()
        }
    }

    func collapse() {
        stopMouseTracking()
        hoverTimer?.invalidate()

        guard isExpanded else {
            withAnimation {
                self.isHovered = false
            }
            return
        }

        withAnimation(
            .spring(
                response: 0.35,
                dampingFraction: 0.85
            )
        ) {
            self.isExpanded = false
            self.isHovered = false

            self.cornerRadius = self.isHardwareNotched
                ? NotchUtils.shared.collapsedCornerRadius
                : NotchUtils.shared.unnotchedCollapsedCornerRadius
            self.extraNotchPadSize = .init(
                width: self.cornerRadius.top * 2,
                height: 0
            )
        }
    }

    func onHover(
        _ isHovered: Bool,
        shouldExpand: Bool = true
    ) {
        hoverTimer?.invalidate()

        if isHovered {
            if NotchDefaults.shared.hapticFeedback {
                HapticsManager.shared.feedback(
                    pattern: .generic
                )
            }

            if shouldExpand, !isExpanded {
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

            withAnimation {
                self.isHovered = true
            }
        } else {
            if isExpanded {
                if !isPinned {
                    collapse()
                }
            } else {
                withAnimation {
                    self.isHovered = false
                }
            }
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

        startMouseTracking()
    }
}
