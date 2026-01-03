//
//  NowPlayingMediaModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/03/25.
//

import SwiftUI

struct NowPlayingMediaModel: Hashable {
    
    var appBundleIdentifier: String
    var appName: String
    var appIcon: Image
    
    var albumArt: Image?
    
    var album: String
    var artist: String
    var title: String
    
    var elapsedTime: Double
    var totalDuration: Double
    
    var playbackRate: Double
    var isPlaying: Bool
    
    var refreshedAt: Date
    
    static var Placeholder: NowPlayingMediaModel {
        return .init(
            appBundleIdentifier: "<App Bundle Identifier Here>",
            appName: "<App Name Here>",
            appIcon: Image(systemName: "app.fill"),
            albumArt: Image(systemName: "square.fill"),
            album: "<Album Here>",
            artist: "<Artist Here>",
            title: "<Music Title Here>",
            elapsedTime: 0,
            totalDuration: 0,
            playbackRate: 1,
            isPlaying: false,
            refreshedAt: .now
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(appBundleIdentifier)
        hasher.combine(appName)
        
        hasher.combine(album)
        hasher.combine(artist)
        hasher.combine(title)
        
        hasher.combine(elapsedTime)
        hasher.combine(totalDuration)
        
        hasher.combine(isPlaying)
        
        hasher.combine(refreshedAt)
    }
}
