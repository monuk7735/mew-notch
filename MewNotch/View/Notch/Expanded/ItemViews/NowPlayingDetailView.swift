//
//  NowPlayingDetailView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct NowPlayingDetailView: View {
    
    enum ButtonType {
        case togglePlayPause
        case next
        case previous
    }
    
    var namespace: Namespace.ID = Namespace().wrappedValue
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var nowPlayingModel: NowPlayingMediaModel
    
    @State private var hoveredItem: ButtonType? = nil
    
    @State private var distanceTimer: Timer? = nil
    @State private var elapsedTime: TimeInterval = 0
    
    func resetElapsedTimeTimer(
        restart: Bool = true
    ) {
        distanceTimer?.invalidate()
        
        guard restart else {
            return
        }
        
        distanceTimer = .scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true
        ) { _ in
            self.elapsedTime = nowPlayingModel.elapsedTime + nowPlayingModel.refreshedAt.distance(
                to: .now
            )
        }
    }
    
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
                        cornerRadius: notchViewModel.cornerRadius.bottom - 10
                    )
                )
                .overlay {
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
                                contentMode: .fit
                            )
                            .frame(
                                width: 32,
                                height: 32
                            )
                    }
                    .buttonStyle(.plain)
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
                .scaleEffect(
                    nowPlayingModel.isPlaying ? 1.0 : 0.9
                )
                .opacity(
                    nowPlayingModel.isPlaying ? 1.0 : 0.5
                )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(nowPlayingModel.title)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .font(.title3.bold())
                
                Text(nowPlayingModel.album)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .font(.footnote)
                
                Text(nowPlayingModel.artist)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .font(.body.weight(.medium))
                
                VStack(
                    spacing: 2
                ) {
                    HStack {
                        let elapsedTime = Int(
                            min(
                                self.elapsedTime,
                                nowPlayingModel.totalDuration
                            )
                        )
                        let elapsedHours = elapsedTime / 3600
                        let elapsedMinutes = (elapsedTime % 3600) / 60
                        let elapsedSeconds = elapsedTime % 60
                        
                        Text(
                            elapsedHours > 0 ? "\(elapsedHours):" : ""
                            +
                            String(
                                format: "%02d:%02d",
                                elapsedMinutes,
                                elapsedSeconds
                            )
                        )
                        
                        Spacer()
                        
                        let totalDuration = Int(nowPlayingModel.totalDuration)
                        let totalHours = totalDuration / 3600
                        let totalMinutes = (totalDuration % 3600) / 60
                        let totalSeconds = totalDuration % 60
                        
                        Text(
                            totalHours > 0
                            ? String(
                                format: "%02d:%02d:%02d",
                                totalHours,
                                totalMinutes,
                                totalSeconds
                            ) : String(
                                format: "%02d:%02d",
                                totalMinutes,
                                totalSeconds
                            )
                        )
                    }
                    .font(.footnote)
                    
                    Rectangle()
                        .fill(
                            .white.opacity(0.2)
                        )
                        .frame(
                            height: 4
                        )
                        .overlay {
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(
                                        .white
                                    )
                                    .frame(
                                        width: geometry.size.width * (
                                            self.elapsedTime / max(1, nowPlayingModel.totalDuration)
                                        ),
                                        height: geometry.size.height
                                    )
                                    .frame(
                                        width: geometry.size.width,
                                        alignment: .leading
                                    )
                            }
                        }
                        .clipShape(
                            Capsule()
                        )
                }
                .frame(
                    maxHeight: .infinity
                )
                .hidden()
                
                HStack {
                    Button(
                        action: {
                            NowPlaying.shared.previousTrack()
                        }
                    ) {
                        Image(
                            systemName: "backward.end.fill"
                        )
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(
                            width: 24,
                            height: 24
                        )
                        .background {
                            if hoveredItem == .previous {
                                Circle()
                                    .fill(
                                        Color.white.opacity(0.1)
                                    )
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { isHovered in
                        withAnimation {
                            hoveredItem = isHovered ? .previous : nil
                        }
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                    
                    Button(
                        action: {
                            NowPlaying.shared.togglePlayPause()
                        }
                    ) {
                        Image(
                            systemName: nowPlayingModel.isPlaying ? "pause.fill" : "play.fill"
                        )
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(
                            width: 24,
                            height: 24
                        )
                        .background {
                            if hoveredItem == .togglePlayPause {
                                Circle()
                                    .fill(
                                        Color.white.opacity(0.1)
                                    )
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { isHovered in
                        withAnimation {
                            hoveredItem = isHovered ? .togglePlayPause : nil
                        }
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                    
                    Button(
                        action: {
                            NowPlaying.shared.nextTrack()
                        }
                    ) {
                        Image(
                            systemName: "forward.end.fill"
                        )
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(
                            width: 24,
                            height: 24
                        )
                        .background {
                            if hoveredItem == .next {
                                Circle()
                                    .fill(
                                        Color.white.opacity(0.1)
                                    )
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { isHovered in
                        withAnimation {
                            hoveredItem = isHovered ? .next : nil
                        }
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(
            width: notchViewModel.notchSize.width * 1.5
        )
        .onChange(
            of: self.nowPlayingModel
        ) {
            self.elapsedTime = $1.elapsedTime
            
            self.resetElapsedTimeTimer(
                restart: $1.isPlaying
            )
        }
        .onAppear {
            self.resetElapsedTimeTimer(
                restart: nowPlayingModel.isPlaying
            )
            
            if nowPlayingModel.isPlaying {
                self.elapsedTime = nowPlayingModel.elapsedTime + nowPlayingModel.refreshedAt.distance(
                    to: .now
                )
            } else {
                self.elapsedTime = nowPlayingModel.elapsedTime
            }
        }
        .onDisappear {
            self.resetElapsedTimeTimer(
                restart: false
            )
        }
    }
}
