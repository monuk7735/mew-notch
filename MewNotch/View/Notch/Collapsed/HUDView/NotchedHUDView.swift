//
//  NotchedHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

import Lottie

struct NotchedHUDView<T: HUDDefaultsProtocol>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults: T
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel, defaults.isEnabled, defaults.style == .Notched && !notchViewModel.isExpanded {
            VStack {
                Rectangle()
                    .opacity(0)
                    .overlay {
                        hud.getIcon()
                    }
                
                RoundedRectangle(
                    cornerRadius: 2
                )
                .fill(
                    .white.opacity(
                        0.1
                    )
                )
                .frame(
                    height: 8
                )
                .overlay {
                    GeometryReader { geometry in
                        RoundedRectangle(
                            cornerRadius: 2
                        )
                        .fill(
                            Color.accentColor
                        )
                        .frame(
                            width: CGFloat(hud.value) * geometry.size.width,
                            height: geometry.size.height
                        )
                        .frame(
                            width: geometry.size.width,
                            alignment: .leading
                        )
                    }
                }
            }
            .padding(
                .init(
                    top: 0,
                    leading: 16,
                    bottom: 16,
                    trailing: 16
                )
            )
            .frame(
                width: notchViewModel.notchSize.width - notchViewModel.extraNotchPadSize.width,
                height: notchViewModel.notchSize.width - notchViewModel.notchSize.height - notchViewModel.extraNotchPadSize.width
            )
            .transition(
                .move(
                    edge: .top
                )
                .combined(
                    with: .opacity
                )
            )
        }
    }
}
