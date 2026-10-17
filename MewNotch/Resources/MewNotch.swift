//
//  MewNotch.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import Lottie
import SwiftUI

enum MewNotch {
    enum IconColor: String, Sendable {
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
            case .blue: Color.Notch.blue
            case .red: Color.Notch.red
            case .green: Color.Notch.green
            case .orange: Color.Notch.orange
            case .yellow: Color.Notch.yellow
            case .pink: Color.Notch.pink
            case .purple: Color.Notch.purple
            case .gray: Color.Notch.gray
            case .cyan: Color.Notch.cyan
            case .indigo: Color.Notch.indigo
            case .teal: Color.Notch.teal
            }
        }
    }

    enum Assets {
        static var iconMenuBar: Image {
            AppAsset.menuBarIcon
        }

        static var iconBrightness: Image {
            AppAsset.brightness
        }

        static var iconSpeaker: Image {
            AppAsset.speaker
        }

        /// Settings Icons (SF Symbols)
        static var icGeneral: Image {
            AppIcon.general.image
        }

        static var icNotch: Image {
            AppIcon.notch.image
        }

        static var icMirror: Image {
            AppIcon.mirror.image
        }

        static var icNowPlaying: Image {
            AppIcon.nowPlaying.image
        }

        static var icHud: Image {
            AppIcon.hud.image
        }

        static var icAudio: Image {
            AppIcon.audio.image
        }

        static var icBrightnessFill: Image {
            AppIcon.brightnessFill.image
        }

        static var icPower: Image {
            AppIcon.power.image
        }

        static var icMedia: Image {
            AppIcon.media.image
        }

        static var icAbout: Image {
            AppIcon.about.image
        }

        static var icTimer: Image {
            AppIcon.timer.image
        }

        static var icVideo: Image {
            AppIcon.video.image
        }

        static var icDisplay: Image {
            AppIcon.display.image
        }

        static var icLock: Image {
            AppIcon.lock.image
        }

        static var icReset: Image {
            AppIcon.reset.image
        }

        static var icHeight: Image {
            AppIcon.height.image
        }

        static var icGlass: Image {
            AppIcon.glass.image
        }

        static var icHover: Image {
            AppIcon.hover.image
        }

        static var icHaptic: Image {
            AppIcon.haptic.image
        }

        static var icCornerRadius: Image {
            AppIcon.cornerRadius.image
        }

        static var icSeparator: Image {
            AppIcon.separator.image
        }

        static var icAlbumArt: Image {
            AppIcon.albumArt.image
        }

        static var icArtist: Image {
            AppIcon.artist.image
        }

        static var icAlbumName: Image {
            AppIcon.albumName.image
        }

        static var icAppIcon: Image {
            AppIcon.appIcon.image
        }

        static var icSeekbar: Image {
            AppIcon.seekbar.image
        }

        /// HUD Detail Icons
        static var icMicrophone: Image {
            AppIcon.microphone.image
        }

        static var icPaintbrush: Image {
            AppIcon.paintbrush.image
        }

        static var icSpeakerWave2: Image {
            AppIcon.speakerWave2.image
        }

        static var icChartBar: Image {
            AppIcon.chartBar.image
        }

        static var icBoltBadgeAutomatic: Image {
            AppIcon.boltBadgeAutomatic.image
        }

        /// General Settings Icons
        static var icLaunchAtLogin: Image {
            AppIcon.launchAtLogin.image
        }

        static var icStatusIcon: Image {
            AppIcon.statusIcon.image
        }

        static var icDisableSystemHud: Image {
            AppIcon.disableSystemHud.image
        }

        static var icWarning: Image {
            AppIcon.warning.image
        }
    }

    enum Colors {
        static let general = IconColor.gray
        static let notch = IconColor.blue

        static let mirror = IconColor.purple
        static let nowPlaying = IconColor.pink

        static let hud = IconColor.orange
        static let audio = IconColor.blue
        static let brightness = IconColor.yellow
        static let power = IconColor.green
        static let timer = IconColor.gray

        static let about = IconColor.gray

        static let lock = IconColor.gray
        static let height = IconColor.orange
        static let glass = IconColor.cyan
        static let hover = IconColor.indigo
        static let haptic = IconColor.teal
        static let separator = IconColor.gray

        static let albumArt = IconColor.blue
        static let artist = IconColor.green
        static let albumName = IconColor.purple
        static let appIcon = IconColor.orange
        static let seekbar = IconColor.red

        static let input = IconColor.green
        static let style = IconColor.blue
        static let output = IconColor.green
        static let stepSize = IconColor.orange
        static let autoBrightness = IconColor.green
        static let systemHud = IconColor.red
        static let video = IconColor.purple
    }

    enum Lotties {
        static var brightness: LottieAnimation? {
            AppAnimation.brightness
        }

        static var speaker: LottieAnimation? {
            AppAnimation.speaker
        }

        static var visualizer: LottieAnimation? {
            AppAnimation.visualizer
        }

        static var lock: LottieAnimation? {
            AppAnimation.lock
        }
    }
}
