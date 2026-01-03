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
    @StateObject private var nowPlayingDefaults = NowPlayingDefaults.shared
    
    var nowPlayingModel: NowPlayingMediaModel
    
    @State private var hoveredItem: ButtonType? = nil
    @State private var isAppIconHovered: Bool = false
    
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
            (nowPlayingModel.albumArt ?? NowPlayingMediaModel.Placeholder.albumArt!)
                .resizable()
                .aspectRatio(
                    1,
                    contentMode: .fit
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: nowPlayingDefaults.albumArtCornerRadius
                    )
                )
                .overlay {
                    if nowPlayingDefaults.showAppIcon {
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
                                .scaleEffect(isAppIconHovered ? 1.1 : 1.0)
                                .shadow(
                                    color: .black.opacity(isAppIconHovered ? 0.5 : 0.2),
                                    radius: isAppIconHovered ? 4 : 2,
                                    x: 0,
                                    y: 2
                                )
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAppIconHovered)
                        }
                        .buttonStyle(.plain)
                        .onHover { isHovered in
                            isAppIconHovered = isHovered
                        }
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
                    .font(.headline)
                
                if nowPlayingDefaults.showArtist {
                    Text(nowPlayingModel.artist)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if nowPlayingDefaults.showAlbum {
                    Text(nowPlayingModel.album)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(
                    spacing: 6
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
                        .monospacedDigit()
                        
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
                        .monospacedDigit()
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(.white.opacity(0.2))
                            
                            Capsule()
                                .fill(.white)
                                .frame(
                                    width: geometry.size.width * (
                                        self.elapsedTime / max(1, nowPlayingModel.totalDuration)
                                    )
                                )
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.vertical, 4)
                
                HStack(spacing: 16) {
                    MediaControlButton(
                        iconName: "backward.end.fill",
                        action: { NowPlaying.shared.previousTrack() },
                        size: 24,
                        isPrimary: false
                    )
                    
                    MediaControlButton(
                        iconName: nowPlayingModel.isPlaying ? "pause.fill" : "play.fill",
                        action: { NowPlaying.shared.togglePlayPause() },
                        size: 36,
                        isPrimary: true
                    )
                    
                    MediaControlButton(
                        iconName: "forward.end.fill",
                        action: { NowPlaying.shared.nextTrack() },
                        size: 24,
                        isPrimary: false
                    )
                }
                .padding(.top, 4)
                .padding(.bottom, 8)
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

struct MediaControlButton: View {
    let iconName: String
    let action: () -> Void
    let size: CGFloat
    let isPrimary: Bool
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .padding(isPrimary ? 8 : 6)
                .frame(width: size, height: size)
                .background {
                    Circle()
                        .fill(
                            .white.opacity(
                                isHovered ? 0.3 : 0.15
                            )
                        )
                }
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .frame(maxWidth: .infinity)
    }
}
