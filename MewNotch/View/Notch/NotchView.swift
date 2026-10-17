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

    @State private var meltProgress: CGFloat = 0.0
    @State private var notchContentSize: CGSize = .zero

    init(
        screen: NSScreen
    ) {
        _notchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
        _collapsedNotchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
    }

    var isNotchVisible: Bool {
        if notchViewModel.isHardwareNotched {
            return true
        }

        if collapsedNotchViewModel.isAuxiliaryScreen {
            return collapsedNotchViewModel.hasActiveContent
        }

        return notchViewModel.isExpanded ||
            notchViewModel.isHovered ||
            notchViewModel.isDropTarget ||
            collapsedNotchViewModel.hasActiveContent
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()

                let currentShape = notchViewModel.currentShape
                let isVisible = isNotchVisible
                let currentWidth = notchContentSize.width > 0 ? notchContentSize.width : notchViewModel.notchSize.width
                let currentHeight = notchContentSize.height > 0 ? notchContentSize.height : notchViewModel.notchSize.height

                Group {
                    if notchViewModel.isHardwareNotched {
                        notchContent
                            .glassEffect(when: notchDefaults.applyGlassEffect, in: currentShape)
                            .background {
                                if !notchDefaults.applyGlassEffect {
                                    Color.black
                                }
                            }
                            .mask {
                                currentShape
                            }
                            .contentShape(
                                currentShape
                            )
                    } else {
                        LiquidMeltContainer(
                            progress: meltProgress,
                            width: currentWidth,
                            height: currentHeight,
                            cornerRadius: notchViewModel.floatingCornerRadius,
                            isHardwareNotched: false,
                            applyGlassEffect: notchDefaults.applyGlassEffect,
                            hardwareShape: currentShape
                        ) {
                            notchContent
                        }
                    }
                }
                .scaleEffect(
                    notchViewModel.isHovered && !notchViewModel.isExpanded ? 1.05 : 1.0,
                    anchor: .top
                )
                .shadow(
                    color: notchViewModel.isHardwareNotched
                        ? Color.black.opacity(notchViewModel.isHovered ? 0.3 : 0)
                        : (isVisible ? Color.black.opacity(0.25) : .clear),
                    radius: notchViewModel.isHardwareNotched
                        ? (notchViewModel.isHovered ? 5 : 0)
                        : (notchViewModel.isExpanded ? 16 : 8),
                    x: 0,
                    y: notchViewModel.isHardwareNotched ? 0 : (notchViewModel.isExpanded ? 6 : 3)
                )
                .onChange(of: isNotchVisible, initial: true) { _, visible in
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                        meltProgress = visible ? 1.0 : 0.0
                    }
                }
                .onHover {
                    guard !collapsedNotchViewModel.isAuxiliaryScreen else { return }
                    notchViewModel.onHover(
                        $0,
                        shouldExpand: notchDefaults.expandOnHover || notchDefaults.applyGlassEffect
                    )
                }
                .overlay {
                    if !notchViewModel.isHardwareNotched, !isVisible, !collapsedNotchViewModel.isAuxiliaryScreen {
                        Color.clear
                            .frame(width: 140, height: 36)
                            .contentShape(Rectangle())
                            .onHover {
                                notchViewModel.onHover(
                                    $0,
                                    shouldExpand: notchDefaults.expandOnHover || notchDefaults.applyGlassEffect
                                )
                            }
                    }
                }
                .dropDestination(
                    for: URL.self,
                    action: { fileURLs, _ in
                        guard !collapsedNotchViewModel.isAuxiliaryScreen else { return false }
                        DispatchQueue.global(qos: .utility).async {
                            guard let groupModel = ShelfFileGroupModel(
                                urls: fileURLs
                            ) else {
                                print("groupModel could not be initialized")
                                return
                            }

                            DispatchQueue.main.async {
                                withAnimation {
                                    expandedNotchViewModel.shelfFileGroups.append(
                                        groupModel
                                    )
                                }
                            }
                        }

                        return true
                    },
                    isTargeted: {
                        notchViewModel.isDropTarget = $0
                    }
                )
                .onChange(
                    of: notchViewModel.isDropTarget
                ) { oldValue, newValue in
                    guard oldValue != newValue else { return }

                    if newValue {
                        expandedNotchViewModel.currentView = .shelf

                        notchViewModel.onTap()
                    } else {
                        notchViewModel.onHover(
                            notchViewModel.isHovered
                        )
                    }
                }
                .onTapGesture {
                    guard !collapsedNotchViewModel.isAuxiliaryScreen else { return }
                    notchViewModel.onTap()
                }

                Spacer()
            }

            Spacer()
        }
        .preferredColorScheme(.dark)
        .contextMenu {
            NotchOptionsView()
        }
    }

    private var notchContent: some View {
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
                .opacity(notchViewModel.isExpanded ? 0 : 1)
                .allowsHitTesting(!notchViewModel.isExpanded)
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: NotchFramePreferenceKey.self,
                        value: proxy.frame(in: .global)
                    )
            }
        )
        .onPreferenceChange(NotchFramePreferenceKey.self) { frame in
            if frame.width > 0, frame.height > 0 {
                notchContentSize = frame.size
            }
            if meltProgress > 0.95 || notchViewModel.isHardwareNotched {
                notchViewModel.updateNotchFrame(frame)
            }
        }
    }
}

private struct NotchFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(
        value: inout CGRect,
        nextValue: () -> CGRect
    ) {
        value = nextValue()
    }
}
