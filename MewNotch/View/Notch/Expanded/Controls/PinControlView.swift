//
//  PinControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/04/25.
//

import SwiftUI

struct PinControlView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var body: some View {
        NotchControlButton(
            notchViewModel: notchViewModel,
            icon: notchViewModel.isPinned ? "pin" : "pin",
            isSelected: notchViewModel.isPinned
        ) {
            withAnimation {
                notchViewModel.isPinned.toggle()
            }
        }
        .rotationEffect(.degrees(notchViewModel.isPinned ? 25 : 0))
    }
}
