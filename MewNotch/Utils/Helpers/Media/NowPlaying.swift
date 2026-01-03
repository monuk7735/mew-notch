//
//  NoewPlaying.swift
//  MewNotch
//
//  Created by Monu Kumar on 24/11/25.
//

import SwiftUI
import AppKit
import Combine
import SwiftyJSON

extension Notification.Name {
    static let NowPlayingInfo = Notification.Name("NowPlayingInfo")
}

fileprivate enum MRCommand: Int {
    case MRPlay = 0
    case MRPause = 1
    case MRTogglePlayPause = 2
    case MRStop = 3
    
    case MRNextTrack = 4
    case MRPreviousTrack = 5
    
    case MRToggleShuffle = 6
    case MRToggleRepeat = 7
    
    case MRGoBackFifteenSeconds = 12
    case MRSkipFifteenSeconds = 13
}

final class NowPlaying {

    static let shared: NowPlaying = .init()
    
    private(set) var appBundleIdentifier: String? {
        didSet {
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: appBundleIdentifier.ifNil("")) else {
                return
            }
            
            appName = FileManager.default.displayName(atPath: url.path())
            appIcon = NSWorkspace.shared.icon(forFile: url.path(percentEncoded: false))
        }
    }
    
    var nowPlayingModel: NowPlayingMediaModel? {
        guard let appBundleIdentifier = NowPlaying.shared.appBundleIdentifier,
              let appName = NowPlaying.shared.appName,
              let appIcon = NowPlaying.shared.appIcon,
              let album = NowPlaying.shared.album,
              let artist = NowPlaying.shared.artist,
              let title = NowPlaying.shared.title,
              let elapsedTime = NowPlaying.shared.elapsedTime,
              let totalDuration = NowPlaying.shared.totalDuration,
              let playbackRate = NowPlaying.shared.playbackRate,
              let refreshedAt = NowPlaying.shared.refreshedAt else {
            return nil
        }
        
        var albumArt: Image? = nil
        if let nsAlbumArt = NowPlaying.shared.albumArt {
            albumArt = .init(nsImage: nsAlbumArt)
        }
        
        return NowPlayingMediaModel(
            appBundleIdentifier: appBundleIdentifier,
            appName: appName,
            appIcon: .init(nsImage: appIcon),
            albumArt: albumArt,
            album: album,
            artist: artist,
            title: title,
            elapsedTime: elapsedTime,
            totalDuration: totalDuration,
            playbackRate: playbackRate,
            isPlaying: playing,
            refreshedAt: refreshedAt
        )
    }
    
    private var appName: String?
    private var appIcon: NSImage?
    
    private var albumArt: NSImage?
    
    private var album: String?
    private var artist: String?
    private var title: String?
    
    private var totalDuration: Double?
    private var elapsedTime: Double?
    
    private var playbackRate: Double?
    private var refreshedAt: Date?
    
    private(set) var playing: Bool = false
    
    private var process: Process?
    private var pipeReader: JSONPipeReader?
    private var streamTask: Task<Void, Never>?
    
    private init() { }
    
    func startListener() {
        Task {
            await self.setupNowPlayingObserver()
        }
    }
    
    private func sendCommand(_ command: MRCommand) {
        guard let scriptURL = Bundle.main.url(forResource: "mediaremote-adapter", withExtension: "pl"),
            let frameworkPath = Bundle.main.privateFrameworksPath?.appending("/MediaRemoteAdapter.framework") else {
            return
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/perl")
        process.arguments = [scriptURL.path, frameworkPath, "send", "\(command.rawValue)"]
        
        do {
            try process.run()
        } catch {
            NSLog("Command could not be sent through mediaremote-adapter", error.localizedDescription)
        }
    }
    
    func togglePlayPause() {
        sendCommand(.MRTogglePlayPause)
    }

    func nextTrack() {
        sendCommand(.MRNextTrack)
    }

    func previousTrack() {
        sendCommand(.MRPreviousTrack)
    }
    
    private func setupNowPlayingObserver() async {
        let process = Process()
        guard
            let scriptURL = Bundle.main.url(forResource: "mediaremote-adapter", withExtension: "pl"),
            let frameworkPath = Bundle.main.privateFrameworksPath?.appending("/MediaRemoteAdapter.framework")
        else {
            assertionFailure("Unable to locate mediaremote-adapter.pl or MediaRemoteAdapter.framework in the application bundle.")
            return
        }
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/perl")
        process.arguments = [scriptURL.path, frameworkPath, "stream", "--no-diff"]
        
        let pipeReader = JSONPipeReader()
        process.standardOutput = await pipeReader.getPipe()
        
        self.process = process
        self.pipeReader = pipeReader

        do {
            try process.run()
            streamTask = Task { [weak self] in
                await self?.processJSONStream()
            }
        } catch {
            assertionFailure("Failed to execute mediaremote-adapter.pl: \(error.localizedDescription)")
        }
    }

    private func processJSONStream() async {
        guard let pipeReader = self.pipeReader else { return }
        
        await pipeReader.readJSONLines(as: JSON.self) { [weak self] update in
            await self?.handleAdapterUpdate(update)
        }
    }

    private func handleAdapterUpdate(_ update: JSON) async {
        guard let payload = update.dictionaryValue["payload"]?.dictionaryValue else {
            return
        }
        
        defer {
            NotificationCenter.default.post(name: .NowPlayingInfo, object: nil)
        }
        
        playing = payload[PayloadItem.playing.rawValue]?.boolValue ?? false
        
        title = payload[PayloadItem.title.rawValue]?.stringValue
        artist = payload[PayloadItem.artist.rawValue]?.stringValue
        album = payload[PayloadItem.album.rawValue]?.stringValue
        totalDuration = payload[PayloadItem.duration.rawValue]?.doubleValue
        elapsedTime = payload[PayloadItem.elapsedTime.rawValue]?.doubleValue
        playbackRate = payload[PayloadItem.playbackRate.rawValue]?.doubleValue
        appBundleIdentifier = payload[PayloadItem.bundleIdentifier.rawValue]?.stringValue
        
        if let artworkDataString = payload[PayloadItem.artworkData.rawValue]?.stringValue, let data = Data(
            base64Encoded: artworkDataString.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        ), let nsImage = NSImage(data: data) {
            albumArt = nsImage
        } else {
            albumArt = nil
        }
        
        if let timestamp = payload[PayloadItem.timestamp.rawValue]?.stringValue, let date = ISO8601DateFormatter().date(from: timestamp) {
            refreshedAt = date
        }
    }
}

fileprivate enum PayloadItem: String {
    case title // String
    case artist // String
    case album // String
    
    case duration // Double
    case elapsedTime // Double
    
    case artworkData // String
    case timestamp // String
    
    case playbackRate // Double
    case playing // Bool
    
    case bundleIdentifier // String
}

actor JSONPipeReader {
    private let pipe = Pipe()
    
    func getPipe() -> Pipe { pipe }
    
    func readJSONLines<T: Decodable>(as type: T.Type, onLine: @escaping (T) async -> Void) async {
        do {
            for try await line in pipe.fileHandleForReading.bytes.lines {
                if let data = line.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode(type, from: data) {
                    await onLine(decoded)
                }
            }
        } catch {
            NSLog("Failed to decode JSON line: \(error.localizedDescription)")
        }
    }
}
