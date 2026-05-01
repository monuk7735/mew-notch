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
    @State private var shouldShowMomentarily: Bool = false
    @State private var autoHideTask: Task<Void, Never>?
    
    private var shouldShowIndicator: Bool {
        isHovered || shouldShowMomentarily
    }
    
    var body: some View {
        if let nowPlayingModel {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .left
            ) {
                (nowPlayingModel.albumArt ?? nowPlayingModel.appIcon)
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
                            self.isHovered = isHovered && !notchDefaults.expandOnHover && notchDefaults.applyGlassEffect
                        }
                    }
            }
            .hide(
                when: !shouldShowIndicator
            )
            .onAppear {
                scheduleAutoHide()
            }
            .onDisappear {
                autoHideTask?.cancel()
            }
            .onChange(of: nowPlayingModel.title) { _, _ in
                scheduleAutoHide()
            }
            .onChange(of: nowPlayingModel.artist) { _, _ in
                scheduleAutoHide()
            }
            .onChange(of: nowPlayingModel.album) { _, _ in
                scheduleAutoHide()
            }
            .onChange(of: nowPlayingModel.isPlaying) { _, _ in
                scheduleAutoHide()
            }
        }
    }
    
    private func scheduleAutoHide() {
        autoHideTask?.cancel()
        
        withAnimation {
            shouldShowMomentarily = true
        }
        
        autoHideTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            
            if !Task.isCancelled {
                withAnimation {
                    shouldShowMomentarily = false
                }
            }
        }
    }
}
