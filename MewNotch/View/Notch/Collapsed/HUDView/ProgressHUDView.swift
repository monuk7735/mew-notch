//
//  ProgressHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

import Lottie

struct ProgressHUDView<T: HUDDefaultsProtocol>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults: T
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel, defaults.isEnabled, defaults.style == .Progress && !notchViewModel.isExpanded {
            VStack {
                HStack {
                    Text(
                        "000 %"
                    )
                    .font(.title3.bold())
                    .opacity(0)
                    .overlay {
                        hud.getIcon()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Text(
                        "000 %"
                    )
                    .font(.title3.bold())
                    .opacity(0)
                    .overlay {
                        AnimatedTextView(
                            value: Double(hud.value * 100)
                        ) { value in
                            Text(
                                String(
                                    format: "%02.0f %",
                                    value
                                )
                            )
                            .font(.title3.bold())
                            .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                RoundedRectangle(
                    cornerRadius: 99
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
                        Rectangle()
                            .fill(Color.accentColor)
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
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 99
                    )
                )
                .background {
                    RoundedRectangle(
                        cornerRadius: 99
                    )
                    .fill(
                        .white.opacity(
                            0.2
                        )
                    )
                    .blur(
                        radius: 3
                    )
                }
            }
            .padding(
                .init(
                    top: 0,
                    leading: 10,
                    bottom: 10,
                    trailing: 10
                )
            )
            .padding(
                .horizontal, notchViewModel.extraNotchPadSize.width / 2
            )
            .frame(
                width: notchViewModel.notchSize.width
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
