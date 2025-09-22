//
//  ExpandedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct ExpandedNotchView: View {
    
    var namespace: Namespace.ID
    
    @Namespace private var nilNamespace
    
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var collapsedNotchView: CollapsedNotchView
    
    var body: some View {
        VStack {
            HStack(
                alignment: .top,
                spacing: 4
            ) {
                NotchViewTypeControlView(
                    notchViewModel: notchViewModel,
                    expandedNotchViewModel: expandedNotchViewModel,
                    notchViewType: .Home
                )
                
                NotchViewTypeControlView(
                    notchViewModel: notchViewModel,
                    expandedNotchViewModel: expandedNotchViewModel,
                    notchViewType: .Shelf
                )
                
                collapsedNotchView
                .opacity(0)
                .disabled(true)
                
                SettingsControlView(
                    notchViewModel: notchViewModel
                )
                
                PinControlView(
                    notchViewModel: notchViewModel
                )
            }
            .zIndex(5)
            
            ZStack {
                NotchHomeView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    expandedNotchViewModel: expandedNotchViewModel,
                    collapsedNotchView: collapsedNotchView
                )
                .opacity(
                    expandedNotchViewModel.currentView != .Home ? 0 : 1
                )
                
                switch expandedNotchViewModel.currentView {
                case .Home:
                    EmptyView()
                case .Shelf:
                    FileShelfView(
                        notchViewModel: notchViewModel,
                        expandedNotchViewModel: expandedNotchViewModel
                    )
                }
            }
        }
        .padding(
            .init(
                top: 0,
                leading: 8 + notchViewModel.extraNotchPadSize.width / 2,
                bottom: 8,
                trailing: 8 + notchViewModel.extraNotchPadSize.width / 2
            )
        )
        .scaleEffect(
            notchViewModel.isExpanded ? 1 : 0.3,
            anchor: .top
        )
        .frame(
            width: notchViewModel.isExpanded ? nil : 0,
            height: notchViewModel.isExpanded ? nil : 0
        )
        .opacity(notchViewModel.isExpanded ? 1 : 0)
        .onChange(
            of: notchViewModel.isExpanded
        ) { old, new in
            if old != new && !new {
                withAnimation {
                    expandedNotchViewModel.currentView = .Home
                }
            }
        }
    }
}
