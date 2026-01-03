//
//  MewNotch.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

import Lottie

class MewNotch {
    
    enum IconColor: String {
        case blue
        case red
        case green
        case orange
        case yellow
        case pink
        case purple
        case gray
        case cyan
        case indigo
        case teal
        
        var color: Color {
            switch self {
            case .blue: return Color(red: 0.298, green: 0.686, blue: 0.969)  // Soft Blue
            case .red: return Color(red: 1.0, green: 0.498, blue: 0.498)     // Soft Red
            case .green: return Color(red: 0.353, green: 0.824, blue: 0.588) // Soft Green
            case .orange: return Color(red: 1.0, green: 0.698, blue: 0.4)    // Soft Orange
            case .yellow: return Color(red: 1.0, green: 0.843, blue: 0.0)    // Soft Yellow (Gold)
            case .pink: return Color(red: 1.0, green: 0.627, blue: 0.784)    // Soft Pink
            case .purple: return Color(red: 0.725, green: 0.518, blue: 0.933)// Soft Purple
            case .gray: return Color(red: 0.663, green: 0.663, blue: 0.663)  // Soft Gray
            case .cyan: return Color(red: 0.4, green: 0.9, blue: 0.95)       // Soft Cyan
            case .indigo: return Color(red: 0.45, green: 0.5, blue: 0.85)    // Soft Indigo
            case .teal: return Color(red: 0.4, green: 0.8, blue: 0.8)        // Soft Teal
            }
        }
    }

    class Assets {
        static let iconMenuBar = Image("MenuBarIcon")
        
        static let iconBrightness = Image("Brightness")
        static let iconSpeaker = Image("Speaker")
        
        // Settings Icons (SF Symbols)
        static let icGeneral = Image(systemName: "gear")
        static let icNotch = Image(systemName: "macbook")
        static let icMirror = Image(systemName: "person.crop.square.fill")
        static let icNowPlaying = Image(systemName: "music.note")
        static let icHud = Image(systemName: "slider.horizontal.3")
        static let icAudio = Image(systemName: "speaker.wave.3.fill")
        static let icBrightnessFill = Image(systemName: "sun.max.fill")
        static let icPower = Image(systemName: "bolt.fill")
        static let icMedia = Image(systemName: "music.note")
        static let icAbout = Image(systemName: "info.circle")
        
        static let icDisplay = Image(systemName: "display")
        static let icLock = Image(systemName: "lock.fill")
        static let icReset = Image(systemName: "arrow.counterclockwise")
        static let icHeight = Image(systemName: "ruler.fill")
        static let icGlass = Image(systemName: "sparkles")
        static let icHover = Image(systemName: "cursorarrow.rays")
        static let icCornerRadius = Image(systemName: "app.dashed")
        static let icSeparator = Image(systemName: "line.3.horizontal")
        
        static let icAlbumArt = Image(systemName: "photo")
        static let icArtist = Image(systemName: "music.mic")
        static let icAlbumName = Image(systemName: "music.note.list")
        static let icAppIcon = Image(systemName: "app.fill")
        
        // HUD Detail Icons
        static let icMicrophone = Image(systemName: "mic.fill")
        static let icPaintbrush = Image(systemName: "paintbrush.fill")
        static let icSpeakerWave2 = Image(systemName: "speaker.wave.2.fill")
        static let icChartBar = Image(systemName: "chart.bar.fill")
        static let icBoltBadgeAutomatic = Image(systemName: "bolt.badge.automatic.fill")
        
        // General Settings Icons
        static let icLaunchAtLogin = Image(systemName: "arrow.up.circle.fill")
        static let icStatusIcon = Image(systemName: "menubar.rectangle")
        static let icDisableSystemHud = Image(systemName: "eye.slash.fill")
        static let icWarning = Image(systemName: "exclamationmark.triangle.fill")
    }
    
    class Colors {
        static let general = IconColor.gray
        static let notch = IconColor.blue
        
        static let mirror = IconColor.purple
        static let nowPlaying = IconColor.pink
        
        static let hud = IconColor.orange
        static let audio = IconColor.blue
        static let brightness = IconColor.yellow
        static let power = IconColor.green
        
        static let about = IconColor.gray
        
        static let lock = IconColor.gray
        static let height = IconColor.orange
        static let glass = IconColor.cyan
        static let hover = IconColor.indigo
        static let separator = IconColor.gray
        
        static let albumArt = IconColor.blue
        static let artist = IconColor.green
        static let albumName = IconColor.purple
        static let appIcon = IconColor.orange
        
        static let input = IconColor.green
        static let style = IconColor.blue
        static let output = IconColor.green
        static let stepSize = IconColor.orange
        static let autoBrightness = IconColor.green
        static let systemHud = IconColor.red
    }
    
    class Lotties {
        static let brightness = LottieAnimation.named("Brightness.json")
        static let speaker = LottieAnimation.named("Speaker.json")
        static let visualizer = LottieAnimation.named("Visualizer.json")
        static let lock = LottieAnimation.named("Lock.json")
    }
    
}
