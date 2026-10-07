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
                    let formattedDuration = hud.value.formattedDuration(allowedUnits: [.hours, .minutes], width: .narrow)
                    Text("\(formattedDuration) Left", comment: "Time remaining for battery HUD")
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
