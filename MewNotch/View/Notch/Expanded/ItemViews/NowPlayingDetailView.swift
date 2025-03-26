//
//  NowPlayingDetailView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct NowPlayingDetailView: View {
    
    var namespace: Namespace.ID = Namespace().wrappedValue
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var nowPlayingModel: NowPlayingMediaModel
    
    var body: some View {
        HStack(
            spacing: 8
        ) {
            nowPlayingModel.albumArt
                .resizable()
                .aspectRatio(
                    1,
                    contentMode: .fit
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                )
                .overlay {
                    nowPlayingModel.appIcon
                        .resizable()
                        .aspectRatio(
                            1,
                            contentMode: .fit
                        )
                        .frame(
                            width: 32,
                            height: 32
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottomTrailing
                        )
                        .padding(
                            .bottom,
                            -4
                        )
                        .padding(
                            .trailing,
                            -4
                        )
                }
                .matchedGeometryEffect(
                    id: "NowPlayingAlbumArt",
                    in: namespace
                )
            
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                Text(nowPlayingModel.title)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .font(.title3.bold())
                
                Text(nowPlayingModel.album)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .font(.footnote)
                
                Text(nowPlayingModel.artist)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .font(.body.weight(.medium))
                
                Spacer()
                
                HStack {
                    Button(
                        action: {
                            MediaController.sharedInstance().previous()
                        }
                    ) {
                        Image(
                            systemName: "backward.end.fill"
                        )
                        .resizable()
                        .scaledToFit()
                    }
                    .buttonStyle(.plain)
                    .frame(
                        maxWidth: 16,
                        maxHeight: 16
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    
                    Button(
                        action: {
                            MediaController.sharedInstance().togglePlayPause()
                        }
                    ) {
                        Image(
                            systemName: nowPlayingModel.isPlaying ? "pause.fill" : "play.fill"
                        )
                        .resizable()
                        .scaledToFit()
                    }
                    .buttonStyle(.plain)
                    .frame(
                        maxWidth: 16,
                        maxHeight: 16
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    
                    Button(
                        action: {
                            MediaController.sharedInstance().next()
                        }
                    ) {
                        Image(
                            systemName: "forward.end.fill"
                        )
                        .resizable()
                        .scaledToFit()
                    }
                    .buttonStyle(.plain)
                    .frame(
                        maxWidth: 16,
                        maxHeight: 16
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(
            .init(
                top: 0,
                leading: 8 + notchViewModel.extraNotchPadSize.width / 2,
                bottom: 8,
                trailing: 8 + notchViewModel.extraNotchPadSize.width / 2
            )
        )
        .frame(
            width: notchViewModel.notchSize.width * 1.5,
            height: notchViewModel.notchSize.height * 2.5
        )
    }
}
