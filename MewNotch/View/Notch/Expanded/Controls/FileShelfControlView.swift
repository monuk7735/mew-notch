//
//  FileShelfControlView.swift (Refactored to NotchTabSwitcherView)
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//

import SwiftUI

struct NotchTabSwitcherView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var spacing: CGFloat
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: spacing) {
            tabButton(for: .Home)
            tabButton(for: .Shelf)
        }
        .padding(3)
        .background {
            Capsule()
                .fill(Color.primary.opacity(0.2))
        }
        .clipShape(Capsule())
        .frame(height: notchViewModel.notchSize.height * 0.8)
    }
    
    @ViewBuilder
    private func tabButton(for type: ExpandedNotchViewModel.NotchViewType) -> some View {
        NotchControlButton(
            notchViewModel: notchViewModel,
            icon: type.imageSystemName,
            isSelected: expandedNotchViewModel.currentView == type,
            padding: 0,
        ) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                expandedNotchViewModel.currentView = type
            }
        }
//        Button {
//            
//        } label: {
//            Image(systemName: type.imageSystemName)
//                .resizable()
//                .scaledToFit()
//                .padding(0)
//                .frame(
//                    width: notchViewModel.notchSize.height * 0.65,
//                    height: notchViewModel.notchSize.height * 0.65
//                )
//                .foregroundStyle(expandedNotchViewModel.currentView == type ? .blue : .secondary)
//        }
//        .buttonStyle(.plain)
    }
}
