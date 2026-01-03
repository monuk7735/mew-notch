//
//  NowPlayingDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

class NowPlayingDefaults: ObservableObject {
    
    static let shared = NowPlayingDefaults()
    
    private static var PREFIX: String = "Expanded_Now_Playing_"
    
    private init() {}
    
    @AppStorage(PREFIX + "AlbumArtCornerRadius") var albumArtCornerRadius: Double = 12.0 {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @AppStorage(PREFIX + "ShowArtist") var showArtist: Bool = true {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @AppStorage(PREFIX + "ShowAlbum") var showAlbum: Bool = true {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @AppStorage(PREFIX + "ShowAppIcon") var showAppIcon: Bool = true {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}
