//
//  ExpandedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class ExpandedNotchViewModel: ObservableObject {
    enum NotchViewType: String, CaseIterable, Identifiable {
        var id: String {
            rawValue
        }

        case home = "Home"
        case shelf = "Shelf"

        var icon: AppIcon {
            switch self {
            case .home:
                .home
            case .shelf:
                .folder
            }
        }

        var imageSystemName: String {
            icon.systemName
        }
    }

    @Published var currentView: NotchViewType = .home

    @Published var nowPlayingMedia: NowPlayingMediaModel?

    @Published var shelfFileGroups: [ShelfFileGroupModel] = [] {
        didSet {
            ShelfDefaults.shared.shelfFileGroups = shelfFileGroups
        }
    }

    init() {
        startListeners()

        nowPlayingMedia = NowPlaying.shared.nowPlayingModel

        shelfFileGroups = ShelfDefaults.shared.shelfFileGroups
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func startListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )
    }

    @objc func handleNowPlayingMediaChanges() {
        guard let nowPlayingMedia = NowPlaying.shared.nowPlayingModel else {
            return
        }

        DispatchQueue.main.async {
            withAnimation {
                self.nowPlayingMedia = nowPlayingMedia
            }
        }
    }
}
