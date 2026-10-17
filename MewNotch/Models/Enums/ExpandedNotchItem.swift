//
//  ExpandedNotchItem.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//


import Foundation

enum ExpandedNotchItem: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case Mirror
    case NowPlaying
    case Bash
    
    var displayName: String {
        switch self {
        case .Mirror:
            return String(localized: "Mirror", comment: "Label for mirror feature item in expanded notch")
        case .NowPlaying:
            return String(localized: "Now Playing", comment: "Label for now playing media item in expanded notch")
        case .Bash:
            return String(localized: "Bash Command", comment: "Label for bash command output item in expanded notch")
        }
    }
    
    var imageSystemName: String {
        switch self {
        case .Mirror:
            return "video.fill"
        case .NowPlaying:
            return "music.note"
        case .Bash:
            return "terminal"
        }
    }
}
