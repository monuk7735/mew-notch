//
//  ExpandedNotchItem.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//

import Foundation

enum ExpandedNotchItem: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case mirror = "Mirror"
    case nowPlaying = "NowPlaying"
    case bash = "Bash"

    var displayName: String {
        switch self {
        case .mirror:
            String(localized: "Mirror", comment: "Label for mirror feature item in expanded notch")
        case .nowPlaying:
            String(localized: "Now Playing", comment: "Label for now playing media item in expanded notch")
        case .bash:
            String(localized: "Bash Command", comment: "Label for bash command output item in expanded notch")
        }
    }

    var icon: AppIcon {
        switch self {
        case .mirror:
            .video
        case .nowPlaying:
            .media
        case .bash:
            .terminal
        }
    }

    var imageSystemName: String {
        icon.systemName
    }
}
