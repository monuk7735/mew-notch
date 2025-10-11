//
//  NotchViewTypeControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//

import SwiftUI

struct NotchViewTypeControlView: View {
    
    @Namespace private var namespace
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var notchViewType: ExpandedNotchViewModel.NotchViewType
    
    var body: some View {
        GenericControlView(
            notchViewModel: notchViewModel
        ) {
            content()
                .onTapGesture {
                    guard notchViewType != expandedNotchViewModel.currentView else { return }
                    withAnimation {
                        expandedNotchViewModel.currentView = notchViewType
                    }
                }
                .opacity(expandedNotchViewModel.currentView == notchViewType ? 1 : 0.7)
                .foregroundStyle(expandedNotchViewModel.currentView == notchViewType ? .blue : .primary)
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if expandedNotchViewModel.currentView == notchViewType {
            Image(systemName: notchViewType.imageSystemNameSelected)
                .resizable()
                .scaledToFit()
                .matchedGeometryEffect(id: notchViewType, in: namespace)
        } else {
            Image(systemName: notchViewType.imageSystemName)
                .resizable()
                .scaledToFit()
                .matchedGeometryEffect(id: notchViewType, in: namespace)
        }
    }
}
