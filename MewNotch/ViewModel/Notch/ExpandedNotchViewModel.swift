//
//  ExpandedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import Combine
import SwiftUI

class ExpandedNotchViewModel: ObservableObject {
    enum NotchViewType: String, CaseIterable, Identifiable {
        var id: String {
            rawValue
        }

        case home = "Home"
        case shelf = "Shelf"

        var icon: AppIcon {
            switch self {
            case .home:
                .home
            case .shelf:
                .folder
            }
        }

        var imageSystemName: String {
            icon.systemName
        }
    }

    @Published var currentView: NotchViewType = NotchDefaults.shared.defaultView.viewType ?? .home

    @Published var nowPlayingMedia: NowPlayingMediaModel?

    private var isSyncingShelf: Bool = false
    private var cancellables = Set<AnyCancellable>()

    @Published var shelfFileGroups: [ShelfFileGroupModel] = [] {
        didSet {
            guard !isSyncingShelf else { return }
            ShelfDefaults.shared.shelfFileGroups = shelfFileGroups
        }
    }

    init() {
        startListeners()

        nowPlayingMedia = NowPlaying.shared.nowPlayingModel

        shelfFileGroups = ShelfDefaults.shared.shelfFileGroups
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func startListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )

        ShelfDefaults.shared.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                let latest = ShelfDefaults.shared.shelfFileGroups
                guard self.shelfFileGroups != latest else { return }
                self.isSyncingShelf = true
                withAnimation {
                    self.shelfFileGroups = latest
                }
                self.isSyncingShelf = false
            }
            .store(in: &cancellables)
    }

    @objc func handleNowPlayingMediaChanges() {
        guard let nowPlayingMedia = NowPlaying.shared.nowPlayingModel else {
            return
        }

        DispatchQueue.main.async {
            withAnimation {
                self.nowPlayingMedia = nowPlayingMedia
            }
        }
    }

    func addShelfGroup(_ group: ShelfFileGroupModel) {
        withAnimation {
            shelfFileGroups.append(group)
        }
    }

    func removeShelfGroup(id: UUID) {
        guard let group = shelfFileGroups.first(where: { $0.id == id }) else { return }
        group.cleanup()
        withAnimation {
            shelfFileGroups.removeAll { $0.id == id }
        }
    }

    func renameShelfGroup(id: UUID, to newName: String) {
        guard let index = shelfFileGroups.firstIndex(where: { $0.id == id }) else { return }
        var updatedGroup = shelfFileGroups[index]
        updatedGroup.rename(to: newName)
        withAnimation {
            shelfFileGroups[index] = updatedGroup
        }
    }

    func pasteFromClipboard() {
        let pasteboard = NSPasteboard.general
        var fileURLs: [URL] = []

        let options: [NSPasteboard.ReadingOptionKey: Any] = [.urlReadingFileURLsOnly: true]
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: options) as? [URL], !urls.isEmpty {
            fileURLs = urls
        } else if let filePaths = pasteboard.propertyList(forType: .init("NSFilenamesPboardType")) as? [String], !filePaths.isEmpty {
            fileURLs = filePaths.map { URL(fileURLWithPath: $0) }
        }

        if !fileURLs.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                if let group = ShelfFileGroupModel(urls: fileURLs) {
                    DispatchQueue.main.async {
                        self.addShelfGroup(group)
                    }
                }
            }
            return
        }

        var imageData: Data?
        if let pngData = pasteboard.data(forType: .png) {
            imageData = pngData
        } else if let tiffData = pasteboard.data(forType: .tiff) ?? NSImage(pasteboard: pasteboard)?.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) {
            imageData = pngData
        }

        if let imageData {
            DispatchQueue.global(qos: .userInitiated).async {
                if let group = ShelfFileGroupModel(imageData: imageData) {
                    DispatchQueue.main.async {
                        self.addShelfGroup(group)
                    }
                }
            }
        }
    }
}
