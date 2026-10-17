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

    init(
        screen: NSScreen
    ) {
        _notchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()

                let currentShape = notchViewModel.currentShape

                ZStack(
                    alignment: .top
                ) {
                    let collapsedNotchView = CollapsedNotchView(
                        namespace: namespace,
                        notchViewModel: notchViewModel
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
                .glassEffect(when: notchDefaults.applyGlassEffect, in: currentShape)
                .background {
                    if !notchDefaults.applyGlassEffect {
                        Color.black
                    }
                }
                .overlay {
                    if !notchViewModel.isHardwareNotched, !notchDefaults.applyGlassEffect {
                        currentShape
                            .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                    }
                }
                .mask {
                    currentShape
                }
                .contentShape(
                    currentShape
                )
                .scaleEffect(
                    notchViewModel.isHovered && !notchViewModel.isExpanded ? 1.05 : 1.0,
                    anchor: .top
                )
                .shadow(
                    color: notchViewModel.isHardwareNotched
                        ? Color.black.opacity(notchViewModel.isHovered ? 0.3 : 0)
                        : Color.black.opacity(0.25),
                    radius: notchViewModel.isHardwareNotched
                        ? (notchViewModel.isHovered ? 5 : 0)
                        : (notchViewModel.isExpanded ? 16 : 8),
                    x: 0,
                    y: notchViewModel.isHardwareNotched ? 0 : (notchViewModel.isExpanded ? 6 : 3)
                )
                .padding(.top, notchViewModel.isHardwareNotched ? 0 : 8)
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
                    notchViewModel.updateNotchFrame(frame)
                }
                .onHover {
                    notchViewModel.onHover(
                        $0,
                        shouldExpand: notchDefaults.expandOnHover || notchDefaults.applyGlassEffect
                    )
                }
                .dropDestination(
                    for: URL.self,
                    action: { fileURLs, _ in
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
                .onTapGesture(
                    perform: notchViewModel.onTap
                )

                Spacer()
            }

            Spacer()
        }
        .preferredColorScheme(.dark)
        .contextMenu {
            NotchOptionsView()
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
