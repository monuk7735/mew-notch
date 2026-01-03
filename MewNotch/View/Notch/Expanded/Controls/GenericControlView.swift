//
//  GenericControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/04/25.
//

import SwiftUI

struct NotchControlButton: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var icon: String? = nil
    var customIcon: Image? = nil
    var isSelected: Bool = false
    var padding: CGFloat = 3
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if let customIcon = customIcon {
                    customIcon
                        .resizable()
                } else if let icon = icon {
                    Image(systemName: icon)
                        .resizable()
                }
            }
            .scaledToFit()
            .bold()
            .padding(5)
            .frame(
                width: notchViewModel.notchSize.height * 0.7,
                height: notchViewModel.notchSize.height * 0.7
            )
            .background {
                Circle()
                    .fill(
                        isSelected ? Color.blue : .white.opacity(0.2)
                    )
            }
            .foregroundStyle(
                .white
            )
        }
        .buttonStyle(.plain)
        .padding(padding)
    }
}
