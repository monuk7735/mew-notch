//
//  OnlyNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct OnlyNotchView: View {
    var notchSize: CGSize = .zero

    var body: some View {
        Text(
            ""
        )
        .frame(
            width: notchSize.width,
            height: notchSize.height
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    OnlyNotchView()
}
