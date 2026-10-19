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

    private var isSimulatedNotch: Bool {
        !notchViewModel.isHardwareNotched && NotchDefaults.shared.externalNotchStyle == .simulatedNotch
    }

    private var contentPadding: CGFloat {
        if notchViewModel.isHardwareNotched || isSimulatedNotch {
            return notchViewModel.minimalHUDPadding
        }
        return notchViewModel.minimalHUDPadding > 0
            ? notchViewModel.minimalHUDPadding
            : max(4, notchViewModel.notchSize.height * 0.2)
    }

    private var leadingPadding: CGFloat {
        if notchViewModel.isHardwareNotched || isSimulatedNotch {
            return notchViewModel.extraNotchPadSize.width / 2 * (variant == .left ? 1 : -1)
        }
        return variant == .left ? max(4, notchViewModel.minimalHUDPadding) : 0
    }

    private var trailingPadding: CGFloat {
        if notchViewModel.isHardwareNotched || isSimulatedNotch {
            return notchViewModel.extraNotchPadSize.width / 2 * (variant == .left ? -1 : 1)
        }
        return variant == .right ? max(4, notchViewModel.minimalHUDPadding) : 0
    }

    var body: some View {
        content()
            .padding(contentPadding)
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
                    leading: leadingPadding,
                    bottom: 0,
                    trailing: trailingPadding
                )
            )
    }
}
