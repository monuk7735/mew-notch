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
    
    @AppStorage(PREFIX + "ShowAlbumArt") var showAlbumArt: Bool = true {
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
}
