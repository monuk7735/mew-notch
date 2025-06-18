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
        GenericControlView(
            notchViewModel: notchViewModel
        ) {
            Button(
                action: {
                    withAnimation {
                        notchViewModel.isPinned.toggle()
                    }
                }
            ) {
                Image(
                    systemName: notchViewModel.isPinned ? "pin.circle.fill" : "pin.circle"
                )
                .resizable()
                .scaledToFit()
                .rotationEffect(
                    notchViewModel.isPinned ? .degrees(45) : .zero
                )
            }
            .buttonStyle(.plain)
            .foregroundStyle(
                notchViewModel.isPinned ? .blue : .primary
            )
        }
    }
}
