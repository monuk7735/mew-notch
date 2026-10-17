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
                .contentShape(
                    NotchShape(
                        topRadius: notchViewModel.cornerRadius.top,
                        bottomRadius: notchViewModel.cornerRadius.bottom
                    )
                )
                .scaleEffect(
                    notchViewModel.isHovered && !notchViewModel.isExpanded ? 1.1 : 1.0,
                    anchor: .top
                )
                .shadow(
                    radius: notchViewModel.isHovered ? 5 : 0
                )
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
