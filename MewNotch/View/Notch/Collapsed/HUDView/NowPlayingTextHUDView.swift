//
//  NowPlayingTextHUDView.swift
//  MewNotch
//

import SwiftUI

struct NowPlayingTextHUDView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let title = hudModel?.name, !title.isEmpty {
            VStack(
                spacing: 0
            ) {
                Text("Now Playing")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.body.bold())
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: notchViewModel.notchSize.width - notchViewModel.extraNotchPadSize.width)
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
