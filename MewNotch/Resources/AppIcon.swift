//
//  AppIcon.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct AppIcon: Sendable, Hashable, ExpressibleByStringLiteral {
    let systemName: String

    init(_ systemName: String) {
        self.systemName = systemName
    }

    init(stringLiteral value: String) {
        systemName = value
    }

    var image: Image {
        Image(systemName: systemName)
    }

    // Settings Navigation Icons
    static let general = AppIcon("gear")
    static let notch = AppIcon("macbook")
    static let mirror = AppIcon("person.crop.square.fill")
    static let nowPlaying = AppIcon("music.note")
    static let hud = AppIcon("slider.horizontal.3")
    static let audio = AppIcon("speaker.wave.3.fill")
    static let brightnessFill = AppIcon("sun.max.fill")
    static let power = AppIcon("bolt.fill")
    static let media = AppIcon("music.note")
    static let about = AppIcon("info.circle")
    static let timer = AppIcon("timer")
    static let video = AppIcon("video.fill")

    // Notch & Display Settings Icons
    static let display = AppIcon("display")
    static let lock = AppIcon("lock.fill")
    static let reset = AppIcon("arrow.counterclockwise")
    static let height = AppIcon("ruler.fill")
    static let glass = AppIcon("sparkles")
    static let hover = AppIcon("cursorarrow.rays")
    static let haptic = AppIcon("hand.tap.fill")
    static let cornerRadius = AppIcon("app.dashed")
    static let separator = AppIcon("line.3.horizontal")

    // Media & Player Icons
    static let albumArt = AppIcon("photo")
    static let artist = AppIcon("music.mic")
    static let albumName = AppIcon("music.note.list")
    static let appIcon = AppIcon("app.fill")
    static let seekbar = AppIcon("slider.horizontal.3")

    // HUD Detail Icons
    static let microphone = AppIcon("mic.fill")
    static let paintbrush = AppIcon("paintbrush.fill")
    static let speakerWave2 = AppIcon("speaker.wave.2.fill")
    static let chartBar = AppIcon("chart.bar.fill")
    static let boltBadgeAutomatic = AppIcon("bolt.badge.automatic.fill")

    // General Settings Icons
    static let launchAtLogin = AppIcon("arrow.up.circle.fill")
    static let statusIcon = AppIcon("menubar.rectangle")
    static let disableSystemHud = AppIcon("eye.slash.fill")
    static let warning = AppIcon("exclamationmark.triangle.fill")
}

enum AppAsset {
    static var menuBarIcon: Image {
        Image("MenuBarIcon")
    }

    static var brightness: Image {
        Image("Brightness")
    }

    static var speaker: Image {
        Image("Speaker")
    }
}
