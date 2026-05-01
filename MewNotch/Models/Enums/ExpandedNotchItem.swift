//
//  ExpandedNotchItem.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//


enum ExpandedNotchItem: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case Mirror
    case NowPlaying
    case Bash
    case Calendar
    case Clipboard
    case Files
    
    var displayName: String {
        switch self {
        case .Mirror:
            return "Mirror"
        case .NowPlaying:
            return "Now Playing"
        case .Bash:
            return "Bash Command"
        case .Calendar:
            return "Calendar"
        case .Clipboard:
            return "Clipboard"
        case .Files:
            return "Files"
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
        case .Calendar:
            return "calendar"
        case .Clipboard:
            return "clipboard"
        case .Files:
            return "folder.fill"
        }
    }
}
