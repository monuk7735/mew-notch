//
//  AnimatedNumberTextView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct AnimatedTextView<Content: View>: View, Animatable {
    var value: Double

    var content: (Double) -> Content

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    var body: some View {
        content(
            value
        )
    }
}
