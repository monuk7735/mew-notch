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
    @State private var isEditingSlider: Bool = false
    @State private var lastSeekTime: Date? = nil
    
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
            if isEditingSlider { return }
            if let lastSeek = lastSeekTime, Date().timeIntervalSince(lastSeek) < 1.5 { return }
            
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
            if !isEditingSlider {
                let shouldIgnore = lastSeekTime != nil && Date().timeIntervalSince(lastSeekTime!) < 1.5
                if !shouldIgnore {
                    self.elapsedTime = $1.elapsedTime
                }
            }
            
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
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                MarqueeTextView(
                    text: nowPlayingModel.title,
                    font: NSFont.preferredFont(forTextStyle: .headline),
                    leftFade: 12,
                    rightFade: 12,
                    startDelay: 2,
                    alignment: .leading
                )
                
                let subtitle = subtitleText
                if !subtitle.isEmpty {
                    MarqueeTextView(
                        text: subtitle,
                        font: NSFont.preferredFont(forTextStyle: .subheadline),
                        leftFade: 12,
                        rightFade: 12,
                        startDelay: 2,
                        alignment: .leading
                    )
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
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 4)
            
            if nowPlayingDefaults.enableSeekbar {
                VStack(spacing: 2) {
                    HStack {
                        Text(timeString(time: elapsedTime))
                        Spacer()
                        Text("-" + timeString(time: nowPlayingModel.totalDuration - elapsedTime))
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    
                    Slider(
                        value: $elapsedTime,
                        in: 0...nowPlayingModel.totalDuration,
                        onEditingChanged: { editing in
                            isEditingSlider = editing
                            if !editing {
                                lastSeekTime = Date()
                                NowPlaying.shared.seek(to: elapsedTime)
                            }
                        }
                    )
                    .controlSize(.mini)
                    .padding(.vertical, 2)
                }
                .padding(.vertical, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onHover { isHovered in
            isDetailsHovered = isHovered
        }
    }
    
    private func timeString(time: Double) -> String {
        let totalSeconds = Int(max(0, time))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private var subtitleText: String {
        var subtitle = ""
        let artist = nowPlayingModel.artist
        let album = nowPlayingModel.album
        
        if nowPlayingDefaults.showArtist && !artist.isEmpty {
            subtitle += artist
        }
        if nowPlayingDefaults.showAlbum && !album.isEmpty {
            if !subtitle.isEmpty {
                subtitle += " — "
            }
            subtitle += album
        }
        return subtitle
    }
    
    @ViewBuilder
    func albumArtView() -> some View {
        if nowPlayingModel.appBundleIdentifier.isEmpty {
            ZStack {
                RoundedRectangle(cornerRadius: nowPlayingDefaults.albumArtCornerRadius)
                    .fill(Color.gray.opacity(0.3))
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            .aspectRatio(1, contentMode: .fit)
        } else {
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
                                    width: 28,
                                    height: 28
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
                        .padding(.bottom, 2)
                        .padding(.trailing, 2)
                    }
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
                .offset(x: iconName == "play.fill" ? 1.5 : 0)
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
