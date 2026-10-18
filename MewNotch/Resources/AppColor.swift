//
//  AppColor.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

extension Color {
    enum Notch {
        static let blue = Color(red: 0.298, green: 0.686, blue: 0.969)
        static let red = Color(red: 1.0, green: 0.498, blue: 0.498)
        static let green = Color(red: 0.353, green: 0.824, blue: 0.588)
        static let orange = Color(red: 1.0, green: 0.698, blue: 0.4)
        static let yellow = Color(red: 1.0, green: 0.843, blue: 0.0)
        static let pink = Color(red: 1.0, green: 0.627, blue: 0.784)
        static let purple = Color(red: 0.725, green: 0.518, blue: 0.933)
        static let gray = Color(red: 0.663, green: 0.663, blue: 0.663)
        static let cyan = Color(red: 0.4, green: 0.9, blue: 0.95)
        static let indigo = Color(red: 0.45, green: 0.5, blue: 0.85)
        static let teal = Color(red: 0.4, green: 0.8, blue: 0.8)
    }
}

enum AppColor {
    // Navigation / General
    static let general = Color.Notch.gray
    static let notch = Color.Notch.blue
    static let lock = Color.Notch.yellow
    static let externalDisplay = Color.Notch.teal
    static let mirror = Color.Notch.purple
    static let nowPlaying = Color.Notch.pink
    static let hud = Color.Notch.orange
    static let about = Color.Notch.indigo

    // HUD Categories
    static let audio = Color.Notch.blue
    static let brightness = Color.Notch.yellow
    static let power = Color.Notch.green
    static let timer = Color.Notch.gray

    // Notch Configuration
    static let glass = Color.Notch.cyan
    static let hover = Color.Notch.indigo
    static let haptic = Color.Notch.teal
    static let separator = Color.Notch.gray

    // Media
    static let albumArt = Color.Notch.blue
    static let artist = Color.Notch.green
    static let albumName = Color.Notch.purple
    static let appIcon = Color.Notch.orange
    static let seekbar = Color.Notch.red

    // Settings details
    static let input = Color.Notch.green
    static let style = Color.Notch.blue
    static let output = Color.Notch.green
    static let stepSize = Color.Notch.orange
    static let autoBrightness = Color.Notch.green
    static let systemHud = Color.Notch.red
    static let video = Color.Notch.purple

    // Bash Script
    static let bash = Color.Notch.purple
    static let bashCommand = Color.Notch.purple
    static let bashRefresh = Color.Notch.green

    /// Surfaces & Backgrounds
    enum Surface {
        static let darkElevated = Color(white: 0.2)
        static let dark = Color(white: 0.15)
        static let darkSubtle = Color(white: 0.1)
        static let darkDeep = Color(white: 0.05)
        static let overlay = Color.black.opacity(0.3)
    }

    /// Interactive & Selection States
    enum Interactive {
        static let selectedBackground = Color.blue.opacity(0.15)
        static let unselectedBackground = Color.gray.opacity(0.1)
        static let selectedBorder = Color.blue
        static let unselectedBorder = Color.gray.opacity(0.3)
        static let destructive = Color.red.opacity(0.9)
    }
}
