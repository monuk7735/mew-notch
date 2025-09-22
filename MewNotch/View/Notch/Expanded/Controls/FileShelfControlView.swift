//
//  NotchViewTypeControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//

import SwiftUI

struct NotchViewTypeControlView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var notchViewType: ExpandedNotchViewModel.NotchViewType
    
    var body: some View {
        GenericControlView(
            notchViewModel: notchViewModel
        ) {
            Image(systemName: expandedNotchViewModel.currentView == notchViewType ? notchViewType.imageSystemNameSelected : notchViewType.imageSystemName )
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .onTapGesture {
                    withAnimation {
                        guard notchViewType != expandedNotchViewModel.currentView else { return }
                        withAnimation {
                            expandedNotchViewModel.currentView = notchViewType
                        }
                    }
                }
                .opacity(expandedNotchViewModel.currentView == notchViewType ? 1 : 0.7)
                .foregroundStyle(expandedNotchViewModel.currentView == notchViewType ? .blue : .primary)
        }
    }
}
