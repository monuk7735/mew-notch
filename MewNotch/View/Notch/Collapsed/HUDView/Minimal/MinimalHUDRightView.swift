//
//  MinimalHUDRightView.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/03/25.
//

import SwiftUI

struct MinimalHUDRightView<T: HUDDefaultsProtocol>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults: T
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel, defaults.isEnabled, (defaults.style == .Minimal || notchViewModel.isExpanded) {
            AnimatedTextView(
                value: Double(hud.value * 100)
            ) { value in
                Text(
                    String(
                        format: "%02.0f",
                        value
                    )
                )
                .minimumScaleFactor(0.4)
                .font(
                    .title2.weight(
                        .medium
                    )
                )
                .foregroundStyle(Color.white)
                .padding(4)
            }
            .frame(
                width: notchViewModel.notchSize.height,
                height: notchViewModel.notchSize.height
            )
            .transition(
                .move(
                    edge: .leading
                )
                .combined(
                    with: .opacity
                )
            )
            .padding(
                .init(
                    top: 0,
                    leading: -notchViewModel.extraNotchPadSize.width / 2,
                    bottom: 0,
                    trailing: notchViewModel.extraNotchPadSize.width / 2
                )
            )
        }
    }
}
