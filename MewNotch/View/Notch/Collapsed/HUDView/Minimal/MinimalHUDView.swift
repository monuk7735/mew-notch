//
//  MinimalHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/06/25.
//

import SwiftUI

struct MinimalHUDView<Content: View>: View {
    
    enum Variant {
        case left
        case right
    }
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var variant: Variant
    
    var content: () -> Content
    
    var body: some View {
        content()
            .padding(notchViewModel.minimalHUDPadding)
            .frame(
                width: notchViewModel.notchSize.height,
                height: notchViewModel.notchSize.height
            )
            .transition(
                .move(
                    edge: variant == .left ? .trailing : .leading
                )
                .combined(
                    with: .opacity
                )
            )
            .padding(
                .init(
                    top: 0,
                    leading: notchViewModel.extraNotchPadSize.width / 2 * (variant == .left ? 1 : -1),
                    bottom: 0,
                    trailing: notchViewModel.extraNotchPadSize.width / 2 * (variant == .left ? -1 : 1)
                )
            )
    }
}
