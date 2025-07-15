//
//  ExpandedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class ExpandedNotchViewModel: ObservableObject {
    
    enum NotchViewType {
        case Home
        case Shelf
    }
    
    @Published var currentView: NotchViewType = .Home
    
    @Published var nowPlayingMedia: NowPlayingMediaModel?
    
    @Published var shelfFileGroups: [ShelfFileGroupModel] = []
    
    init() {
        self.startListeners()
    }
    
    deinit {
        self.stopListeners()
    }
    
    func startListeners() {
        // MARK: Media Change Listeners
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingState,
            object: nil
        )
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNowPlayingMediaChanges() {
        guard let appBundleIdentifier = NowPlaying.sharedInstance().appBundleIdentifier,
              let appName = NowPlaying.sharedInstance().appName,
              let appIcon = NowPlaying.sharedInstance().appIcon,
              let albumArt = NowPlaying.sharedInstance().albumArt,
              let album = NowPlaying.sharedInstance().album,
              let artist = NowPlaying.sharedInstance().artist,
              let title = NowPlaying.sharedInstance().title,
              let elapsedTime = NowPlaying.sharedInstance().elapsedTime,
              let totalDuration = NowPlaying.sharedInstance().totalDuration,
              let playbackRate = NowPlaying.sharedInstance().playbackRate,
              let refreshedAt = NowPlaying.sharedInstance().refreshedAt else {
            return
        }
        
        withAnimation {
            nowPlayingMedia = .init(
                appBundleIdentifier: appBundleIdentifier,
                appName: appName,
                appIcon: .init(
                    nsImage: appIcon
                ),
                albumArt: .init(
                    nsImage: albumArt
                ),
                album: album,
                artist: artist,
                title: title,
                elapsedTime: elapsedTime.doubleValue,
                totalDuration: totalDuration.doubleValue,
                playbackRate: playbackRate.doubleValue,
                isPlaying: NowPlaying.sharedInstance().playing,
                refreshedAt: refreshedAt
            )
        }
    }
    
}
