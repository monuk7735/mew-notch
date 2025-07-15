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
        self._notchViewModel = .init(
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
                    )
                    
                    collapsedNotchView
                }
                .background {
                    Color.black
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
                    notchViewModel.onHover(
                        $0,
                        shouldExpand: notchDefaults.expandOnHover
                    )
                }
                .dropDestination(
                    for: URL.self,
                    action: { fileURLs, _ in
                        guard let groupModel = ShelfFileGroupModel(
                            urls: fileURLs
                        ) else {
                            print("groupModel could not be initialized")
                            return false
                        }
                        
                        withAnimation {
                            expandedNotchViewModel.shelfFileGroups.append(
                                groupModel
                            )
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
                        expandedNotchViewModel.currentView = .Shelf
                        
                        notchViewModel.onTap()
                    } else {
                        notchViewModel.onHover(
                            notchViewModel.isHovered
                        )
                    }
                }
//                .onDrop(
//                    of: [UTType.fileURL],
//                    isTargeted: .init(
//                        get: { isDropTarget },
//                        set: {
//                            isDropTarget = $0
//                            
//                            print("isDropTarget", isDropTarget)
//                        }
//                    )
//                ) { items in
//                    
//                    print("items", items)
//                    
//                    return true
//                }
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
