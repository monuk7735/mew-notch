//
//  GenericControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/04/25.
//

import SwiftUI

struct NotchControlButton: View {
    @ObservedObject var notchViewModel: NotchViewModel

    var icon: AppIcon?
    var customIcon: Image?
    var isSelected: Bool = false
    var padding: CGFloat = 3
    var action: () -> Void

    init(
        notchViewModel: NotchViewModel,
        icon: AppIcon? = nil,
        customIcon: Image? = nil,
        isSelected: Bool = false,
        padding: CGFloat = 3,
        action: @escaping () -> Void
    ) {
        self.notchViewModel = notchViewModel
        self.icon = icon
        self.customIcon = customIcon
        self.isSelected = isSelected
        self.padding = padding
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                if let customIcon {
                    customIcon
                        .resizable()
                } else if let icon {
                    icon.image
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
                        isSelected ? AppColor.notch : .white.opacity(0.2)
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
