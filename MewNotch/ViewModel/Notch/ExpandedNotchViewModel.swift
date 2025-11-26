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
            self.rawValue
        }
        
        case Home
        case Shelf
        
        var imageSystemName: String {
            switch self {
            case .Home:
                return "house.circle"
            case .Shelf:
                return "bookmark.circle"
            }
        }
        
        var imageSystemNameSelected: String {
            switch self {
            case .Home:
                return "house.circle.fill"
            case .Shelf:
                return "bookmark.circle.fill"
            }
        }
    }
    
    @Published var currentView: NotchViewType = .Home
    
    @Published var nowPlayingMedia: NowPlayingMediaModel?
    
    @Published var shelfFileGroups: [ShelfFileGroupModel] = []
    
    init() {
        self.startListeners()
        
        // Use existing model when Notch is refreshed
        self.nowPlayingMedia = NowPlaying.shared.nowPlayingModel
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
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
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
