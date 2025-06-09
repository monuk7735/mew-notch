//
//  NowPlayingHUDLeftView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

struct NowPlayingHUDLeftView: View {
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    var namespace: Namespace.ID = Namespace().wrappedValue
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var nowPlayingModel: NowPlayingMediaModel?
    
    @State private var isHovered: Bool = false
    
    var body: some View {
        if let nowPlayingModel {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .left
            ) {
                nowPlayingModel.albumArt
                    .resizable()
                    .aspectRatio(
                        1,
                        contentMode: .fill
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
                    .matchedGeometryEffect(
                        id: "NowPlayingAlbumArt",
                        in: namespace
                    )
                    .scaleEffect(
                        nowPlayingModel.isPlaying ? 1.0 : 0.9
                    )
                    .opacity(
                        nowPlayingModel.isPlaying ? 1.0 : 0.5
                    )
                    .opacity(self.isHovered ? 0 : 1)
                    .overlay {
                        if self.isHovered {
                            Button(
                                action: {
                                    guard let url = NSWorkspace.shared.urlForApplication(
                                        withBundleIdentifier: nowPlayingModel.appBundleIdentifier
                                    ) else {
                                        return
                                    }
                                    
                                    NSWorkspace.shared.openApplication(
                                        at: url,
                                        configuration: .init()
                                    )
                                }
                            ) {
                                nowPlayingModel.appIcon
                                    .resizable()
                                    .aspectRatio(
                                        1,
                                        contentMode: .fill
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onHover { isHovered in
                        withAnimation {
                            self.isHovered = isHovered && !notchDefaults.expandOnHover
                        }
                    }
            }
        }
    }
}
