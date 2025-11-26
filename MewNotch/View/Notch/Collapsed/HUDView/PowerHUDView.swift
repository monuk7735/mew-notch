//
//  PowerHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 20/03/25.
//

import SwiftUI

struct PowerHUDView<T: HUDDefaultsProtocol>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults: T
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel, defaults.isEnabled {
            HStack {
                hud.getIcon()
                    .padding(5)
                
                Spacer()
                
                if hud.value.isFinite {
                    let value = Int(hud.value)
                    
                    let hour = value / 3600
                    let min = (value % 3600) / 60
                    
                    (
                        Text(hour > 0 ? "\(hour)" : "")
                        +
                        Text(hour > 0 ? "h " : "")
                        +
                        Text(min > 0 ? "\(min)" : "")
                        +
                        Text(min > 0 ? "m " : "")
                        +
                        Text("Left")
                    )
                } else {
                    Text(
                        hud.name
                    )
                    .font(.title3.bold())
                    .foregroundStyle(Color.white)
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
                width: notchViewModel.notchSize.width,
                height: notchViewModel.notchSize.height
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
