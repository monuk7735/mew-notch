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
    @StateObject private var nowPlayingDefaults = NowPlayingDefaults.shared
    
    var nowPlayingModel: NowPlayingMediaModel
    
    @State private var isAppIconHovered: Bool = false
    @State private var isDetailsHovered: Bool = false
    
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
            albumArtView()
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
            
            detailsView()
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
    
    @ViewBuilder
    func detailsView() -> some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .blur(radius: isDetailsHovered ? 4.0 : 0)
            .animation(.easeInOut(duration: 0.2), value: isDetailsHovered)
            .overlay {
                if isDetailsHovered {
                    HStack(spacing: 8) {
                        MediaControlButton(
                            iconName: "backward.end.fill",
                            action: { NowPlaying.shared.previousTrack() },
                            size: 20,
                            isPrimary: false
                        )
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        
                        MediaControlButton(
                            iconName: nowPlayingModel.isPlaying ? "pause.fill" : "play.fill",
                            action: { NowPlaying.shared.togglePlayPause() },
                            size: 32,
                            isPrimary: true
                        )
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        
                        MediaControlButton(
                            iconName: "forward.end.fill",
                            action: { NowPlaying.shared.nextTrack() },
                            size: 20,
                            isPrimary: false
                        )
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
            .contentShape(Rectangle())
            
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
                
                Spacer()
                
                Slider(
                    value: $elapsedTime,
                    in: 0...nowPlayingModel.totalDuration,
                    onEditingChanged: { editing in
                        if !editing {
//                            NowPlaying.shared.seek(to: elapsedTime)
                        }
                    }
                )
                .controlSize(.mini)
                .disabled(true)
                .padding(.vertical, 2)
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onHover { isHovered in
            isDetailsHovered = isHovered
        }
    }
    
    @ViewBuilder
    func albumArtView() -> some View {
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
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: size)
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
