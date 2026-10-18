//
//  ShelfFileGroupModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import AppKit
import Foundation
import UniformTypeIdentifiers

struct ShelfFileModel: Identifiable, Codable {
    let id: UUID

    var fileURL: URL
    let bookmarkData: Data?

    var fileName: String
    var customName: String?
    let originalURL: URL?

    // Non-Codable properties
    var preview: NSImage
    var itemProvider: NSItemProvider {
        let provider = NSItemProvider(contentsOf: fileURL) ?? NSItemProvider()
        let effectiveName = customName ?? fileName
        provider.suggestedName = (effectiveName as NSString).deletingPathExtension
        return provider
    }

    let addedAt: Date

    var displayName: String {
        customName ?? fileName
    }

    var isImage: Bool {
        let imageExtensions: Set = [
            "png", "jpg", "jpeg", "heic", "heif",
            "tiff", "tif", "gif", "webp", "bmp", "ico", "icns"
        ]
        return imageExtensions.contains(fileURL.pathExtension.lowercased())
    }

    enum CodingKeys: String, CodingKey {
        case id, fileURL, bookmarkData, fileName, customName, originalURL, addedAt
    }

    init?(
        sourceURL: URL,
        preferredName: String? = nil
    ) {
        let storedURL: URL
        do {
            storedURL = try ShelfStorageManager.shared.storeFile(from: sourceURL, preferredName: preferredName)
        } catch {
            print("Failed to store file \(sourceURL) into Shelf: \(error)")
            return nil
        }

        let bookmark = try? storedURL.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        id = UUID()
        fileURL = storedURL
        bookmarkData = bookmark
        fileName = storedURL.lastPathComponent
        customName = preferredName
        originalURL = sourceURL
        preview = storedURL.previewImage()

        addedAt = .now
    }

    init?(
        imageData: Data,
        suggestedName: String? = nil
    ) {
        let storedURL: URL
        do {
            storedURL = try ShelfStorageManager.shared.storeImageData(imageData, suggestedName: suggestedName)
        } catch {
            print("Failed to store image data into Shelf: \(error)")
            return nil
        }

        let bookmark = try? storedURL.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        id = UUID()
        fileURL = storedURL
        bookmarkData = bookmark
        fileName = storedURL.lastPathComponent
        customName = suggestedName
        originalURL = nil
        preview = NSImage(data: imageData) ?? storedURL.previewImage()

        addedAt = .now
    }

    init?(
        existingStoredURL storedURL: URL
    ) {
        guard FileManager.default.fileExists(atPath: storedURL.path) else { return nil }

        let bookmark = try? storedURL.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        id = UUID()
        fileURL = storedURL
        bookmarkData = bookmark
        fileName = storedURL.lastPathComponent
        customName = nil
        originalURL = nil
        preview = storedURL.previewImage()

        addedAt = .now
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        fileName = try container.decode(String.self, forKey: .fileName)
        customName = try? container.decodeIfPresent(String.self, forKey: .customName)
        originalURL = try? container.decodeIfPresent(URL.self, forKey: .originalURL)
        addedAt = try container.decode(Date.self, forKey: .addedAt)
        bookmarkData = try? container.decodeIfPresent(Data.self, forKey: .bookmarkData)

        if let decodedURL = try? container.decodeIfPresent(URL.self, forKey: .fileURL),
           FileManager.default.fileExists(atPath: decodedURL.path) {
            fileURL = decodedURL
        } else if let data = bookmarkData {
            var isStale = false
            do {
                let resolvedURL = try URL(
                    resolvingBookmarkData: data,
                    options: .withSecurityScope,
                    relativeTo: nil,
                    bookmarkDataIsStale: &isStale
                )
                fileURL = resolvedURL
            } catch {
                if let decodedURL = try? container.decodeIfPresent(URL.self, forKey: .fileURL) {
                    fileURL = decodedURL
                } else {
                    throw error
                }
            }
        } else if let decodedURL = try? container.decodeIfPresent(URL.self, forKey: .fileURL) {
            fileURL = decodedURL
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .fileURL,
                in: container,
                debugDescription: "Missing file URL or bookmark data"
            )
        }

        preview = fileURL.previewImage()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fileURL, forKey: .fileURL)
        try container.encode(bookmarkData, forKey: .bookmarkData)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(customName, forKey: .customName)
        try container.encode(originalURL, forKey: .originalURL)
        try container.encode(addedAt, forKey: .addedAt)
    }

    mutating func rename(to newName: String) {
        do {
            let updatedURL = try ShelfStorageManager.shared.renameStoredFile(at: fileURL, to: newName)
            fileURL = updatedURL
            fileName = updatedURL.lastPathComponent
            customName = newName
            preview = updatedURL.previewImage()
        } catch {
            print("Failed to rename shelf file: \(error)")
            customName = newName
        }
    }

    func revealInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([fileURL])
    }

    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([fileURL as NSURL])
    }
}

struct ShelfFileGroupModel: Identifiable, Codable {
    let id: UUID

    var files: [ShelfFileModel]
    var customGroupName: String?
    var folderURL: URL?

    var groupName: String {
        if let customGroupName, !customGroupName.isEmpty {
            return customGroupName
        }
        guard let firstFile = files.first else { return "Group" }
        if files.count > 1 {
            return "\(firstFile.displayName) + \(files.count - 1) more"
        } else {
            return firstFile.displayName
        }
    }

    var displayName: String {
        if let customGroupName, !customGroupName.isEmpty {
            return customGroupName
        }
        guard let firstFile = files.first else { return "Group" }
        return firstFile.displayName
    }

    var isPackagedFolder: Bool {
        files.count > 1 && customGroupName != nil && !(customGroupName?.isEmpty ?? true)
    }

    var preview: NSImage {
        if isPackagedFolder {
            let icon: NSImage = if let folderURL, FileManager.default.fileExists(atPath: folderURL.path) {
                NSWorkspace.shared.icon(forFile: folderURL.path)
            } else {
                NSWorkspace.shared.icon(for: .folder)
            }
            icon.size = NSSize(width: 128, height: 128)
            return icon
        }
        return files.first?.preview ?? NSImage(systemSymbolName: "doc", accessibilityDescription: nil) ?? NSImage()
    }

    var isImage: Bool {
        if isPackagedFolder {
            return false
        }
        return files.first?.isImage ?? false
    }

    enum CodingKeys: String, CodingKey {
        case id, files, customGroupName, groupName, folderURL
    }

    init?(
        urls: [URL],
        groupName: String? = nil
    ) {
        guard !urls.isEmpty else {
            return nil
        }

        let groupID = UUID()
        id = groupID

        if urls.count == 1, let singleURL = urls.first {
            guard let file = ShelfFileModel(sourceURL: singleURL) else { return nil }
            files = [file]
            customGroupName = nil
            folderURL = nil
        } else {
            let initialName = groupName ?? "Files"
            do {
                let (packagedFolder, storedURLs) = try ShelfStorageManager.shared.storeGroup(
                    urls: urls,
                    groupID: groupID,
                    folderName: initialName
                )
                folderURL = packagedFolder
                customGroupName = groupName

                let models = storedURLs.compactMap { ShelfFileModel(existingStoredURL: $0) }
                guard !models.isEmpty else { return nil }
                files = models
            } catch {
                print("Failed to store file group: \(error)")
                let fallback = urls.compactMap { ShelfFileModel(sourceURL: $0) }
                guard !fallback.isEmpty else { return nil }
                files = fallback
                customGroupName = nil
                folderURL = nil
            }
        }
    }

    init?(
        imageData: Data,
        suggestedName: String? = nil
    ) {
        guard let fileModel = ShelfFileModel(imageData: imageData, suggestedName: suggestedName) else {
            return nil
        }

        id = UUID()
        files = [fileModel]
        customGroupName = suggestedName
        folderURL = nil
    }

    init(
        id: UUID = UUID(),
        files: [ShelfFileModel],
        customGroupName: String? = nil,
        folderURL: URL? = nil
    ) {
        self.id = id
        self.files = files
        self.customGroupName = customGroupName
        self.folderURL = folderURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        files = try container.decode([ShelfFileModel].self, forKey: .files)
        customGroupName = (try? container.decodeIfPresent(String.self, forKey: .customGroupName))
            ?? (try? container.decodeIfPresent(String.self, forKey: .groupName))
        folderURL = try? container.decodeIfPresent(URL.self, forKey: .folderURL)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(files, forKey: .files)
        try container.encode(customGroupName, forKey: .customGroupName)
        try container.encode(groupName, forKey: .groupName)
        try container.encodeIfPresent(folderURL, forKey: .folderURL)
    }

    mutating func rename(to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        customGroupName = trimmed
        if files.count == 1 {
            files[0].rename(to: trimmed)
        } else if files.count > 1 {
            do {
                let targetFolder: URL
                if let currentFolder = folderURL, FileManager.default.fileExists(atPath: currentFolder.path) {
                    targetFolder = try ShelfStorageManager.shared.renameStoredFolder(
                        currentFolderURL: currentFolder,
                        to: trimmed
                    )
                } else {
                    let fileURLs = files.map(\.fileURL)
                    let (packaged, _) = try ShelfStorageManager.shared.packageExistingFiles(
                        fileURLs: fileURLs,
                        intoFolderNamed: trimmed,
                        groupID: id
                    )
                    targetFolder = packaged
                }
                folderURL = targetFolder

                for index in 0 ..< files.count {
                    let currentFileName = files[index].fileName
                    let updatedURL = targetFolder.appendingPathComponent(currentFileName)
                    files[index].fileURL = updatedURL
                }
            } catch {
                print("Failed to rename group folder: \(error)")
            }
        }
    }

    func cleanup() {
        if let folderURL {
            ShelfStorageManager.shared.removeStoredItem(at: folderURL)
        }
        for file in files {
            ShelfStorageManager.shared.removeStoredItem(at: file.fileURL)
        }
    }

    func revealInFinder() {
        if isPackagedFolder, let folderURL {
            NSWorkspace.shared.activateFileViewerSelecting([folderURL])
        } else {
            let urls = files.map(\.fileURL)
            NSWorkspace.shared.activateFileViewerSelecting(urls)
        }
    }

    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        if isPackagedFolder, let folderURL {
            pasteboard.writeObjects([folderURL as NSURL])
        } else {
            pasteboard.writeObjects(files.map { $0.fileURL as NSURL })
        }
    }
}
