//
//  NotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct NotchView: View {
    @Namespace var namespace

    @Environment(\.openSettings) private var openSettings

    @StateObject var notchDefaults = NotchDefaults.shared

    @StateObject var notchViewModel: NotchViewModel
    @StateObject var expandedNotchViewModel: ExpandedNotchViewModel = .init()
    @StateObject var collapsedNotchViewModel: CollapsedNotchViewModel

    var isLockScreen: Bool = false

    init(
        screen: NSScreen,
        isLockScreen: Bool = false
    ) {
        self.isLockScreen = isLockScreen
        _notchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
        _collapsedNotchViewModel = .init(
            wrappedValue: .init(
                screen: screen,
                isLockScreen: isLockScreen
            )
        )
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()

                if notchViewModel.isHardwareNotched {
                    hardwareNotchView
                } else {
                    floatingHUDView
                }

                Spacer()
            }

            Spacer()
        }
        .preferredColorScheme(.dark)
        .contextMenu {
            if !isLockScreen {
                NotchOptionsView()
            }
        }
        .onAppear {
            if !notchViewModel.isHardwareNotched, collapsedNotchViewModel.hasActiveContent {
                NotchManager.shared.showAuxiliaryWindow(for: notchViewModel.screen, isLockScreen: isLockScreen)
            }
        }
        .onChange(of: collapsedNotchViewModel.hasActiveContent) { _, hasActive in
            if !notchViewModel.isHardwareNotched {
                if hasActive {
                    NotchManager.shared.showAuxiliaryWindow(for: notchViewModel.screen, isLockScreen: isLockScreen)
                } else {
                    NotchManager.shared.hideAuxiliaryWindow(for: notchViewModel.screen, isLockScreen: isLockScreen, delay: 0.4)
                }
            }
        }
    }

    @ViewBuilder
    private var floatingHUDView: some View {
        if collapsedNotchViewModel.hasActiveContent {
            CompactFloatingHUDView(
                namespace: namespace,
                notchViewModel: notchViewModel,
                collapsedNotchViewModel: collapsedNotchViewModel
            )
        }
    }

    private var hardwareNotchView: some View {
        ZStack(
            alignment: .top
        ) {
            let collapsedNotchView = CollapsedNotchView(
                namespace: namespace,
                notchViewModel: notchViewModel,
                collapsedNotchViewModel: collapsedNotchViewModel
            )

            ExpandedNotchView(
                namespace: namespace,
                notchViewModel: notchViewModel,
                expandedNotchViewModel: expandedNotchViewModel,
                collapsedNotchView: collapsedNotchView
            ).hide(when: !notchViewModel.isExpanded)

            collapsedNotchView
        }
        .glassEffect(when: notchDefaults.applyGlassEffect, in: NotchShape(
            topRadius: notchViewModel.cornerRadius.top,
            bottomRadius: notchViewModel.cornerRadius.bottom
        ))
        .background {
            if !notchDefaults.applyGlassEffect {
                Color.black
            }
        }
        .mask {
            NotchShape(
                topRadius: notchViewModel.cornerRadius.top,
                bottomRadius: notchViewModel.cornerRadius.bottom
            )
        }
        .scaleEffect(
            notchViewModel.isHovered ? 1.1 : 1.0,
            anchor: .top
        )
        .shadow(
            radius: notchViewModel.isHovered ? 5 : 0
        )
        .onHover {
            guard !isLockScreen else { return }
            notchViewModel.onHover(
                $0,
                shouldExpand: notchDefaults.expandOnHover || notchDefaults.applyGlassEffect
            )
        }
        .applyDropDestination(
            isEnabled: !isLockScreen,
            for: URL.self,
            action: { fileURLs, _ in
                guard !ShelfStorageManager.isDraggingFromShelf else { return false }
                let externalURLs = fileURLs.filter { !ShelfStorageManager.shared.isShelfURL($0) }
                guard !externalURLs.isEmpty else { return false }
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let groupModel = ShelfFileGroupModel(
                        urls: externalURLs
                    ) else {
                        return
                    }

                    DispatchQueue.main.async {
                        expandedNotchViewModel.addShelfGroup(
                            groupModel
                        )
                    }
                }

                return true
            },
            isTargeted: { targeted in
                guard !isLockScreen else { return }
                if targeted, ShelfStorageManager.isDraggingFromShelf {
                    notchViewModel.isDropTarget = false
                    return
                }
                notchViewModel.isDropTarget = targeted
            }
        )
        .onChange(
            of: notchViewModel.isDropTarget
        ) { oldValue, newValue in
            guard !isLockScreen, oldValue != newValue else { return }

            if newValue {
                expandedNotchViewModel.currentView = .shelf

                notchViewModel.onTap()
            } else {
                notchViewModel.onHover(
                    notchViewModel.isHovered
                )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isLockScreen else { return }
            notchViewModel.onTap()
        }
    }
}

private extension View {
    @ViewBuilder
    func applyDropDestination(
        isEnabled: Bool,
        for type: URL.Type,
        action: @escaping ([URL], CGPoint) -> Bool,
        isTargeted: @escaping (Bool) -> Void
    ) -> some View {
        if isEnabled {
            dropDestination(for: type, action: action, isTargeted: isTargeted)
        } else {
            self
        }
    }
}
