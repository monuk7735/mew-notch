//
//  OnlyNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct OnlyNotchView: View {
    var notchSize: CGSize = .zero
    var isHardwareNotched: Bool = true
    var hasActiveContent: Bool = false

    var body: some View {
        if isHardwareNotched {
            Text("")
                .frame(
                    width: notchSize.width,
                    height: notchSize.height
                )
        } else if !hasActiveContent {
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 32, height: 4)
                .frame(width: 48, height: notchSize.height)
        }
    }
}

#Preview {
    OnlyNotchView()
}
