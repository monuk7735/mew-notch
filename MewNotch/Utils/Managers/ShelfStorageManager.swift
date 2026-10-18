//
//  ShelfStorageManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import AppKit
import Darwin
import Foundation
import QuickLook
import UniformTypeIdentifiers

final class ShelfStorageManager {
    static let shared = ShelfStorageManager()
    static var isDraggingFromShelf: Bool = false

    private let fileManager = FileManager.default

    let shelfDirectory: URL

    func isShelfURL(_ url: URL) -> Bool {
        url.standardizedFileURL.path.hasPrefix(shelfDirectory.standardizedFileURL.path)
    }

    private init() {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Application Support")
        let shelfDir = appSupport.appendingPathComponent("com.monuk7735.mew.notch/Shelf", isDirectory: true)

        if !fileManager.fileExists(atPath: shelfDir.path) {
            try? fileManager.createDirectory(at: shelfDir, withIntermediateDirectories: true)
        }

        shelfDirectory = shelfDir
    }

    /// Stores a file or directory into the Shelf persistent storage using APFS clonefile (Copy-on-Write)
    /// when possible, falling back to standard copy across filesystems.
    func storeFile(from sourceURL: URL, preferredName: String? = nil) throws -> URL {
        let isScoped = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if isScoped {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let itemDirectory = shelfDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: itemDirectory, withIntermediateDirectories: true)

        let fileName = preferredName ?? sourceURL.lastPathComponent
        let destinationURL = itemDirectory.appendingPathComponent(fileName)

        // Try APFS clonefile first (zero-cost, instant copy-on-write)
        let srcPath = sourceURL.path
        let dstPath = destinationURL.path
        if Darwin.clonefile(srcPath, dstPath, 0) == 0 {
            cacheThumbnail(for: destinationURL, in: itemDirectory)
            return destinationURL
        }

        // Fallback to copyItem (for external volumes or non-APFS volumes)
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        cacheThumbnail(for: destinationURL, in: itemDirectory)
        return destinationURL
    }

    private func cacheThumbnail(for fileURL: URL, in itemDirectory: URL) {
        guard !Thread.isMainThread else { return }
        let thumbnailURL = itemDirectory.appendingPathComponent("thumbnail.png")
        if let cgThumb = QLThumbnailImageCreate(
            kCFAllocatorDefault,
            fileURL as CFURL,
            CGSize(width: 128, height: 128),
            nil
        )?.takeRetainedValue() {
            let nsThumb = NSImage(cgImage: cgThumb, size: .zero)
            if let tiff = nsThumb.tiffRepresentation,
               let rep = NSBitmapImageRep(data: tiff),
               let png = rep.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey: Any]()) {
                try? png.write(to: thumbnailURL, options: .atomic)
            }
        }
    }

    /// Stores raw image data (e.g. from clipboard or screenshot thumbnail) into persistent Shelf storage.
    func storeImageData(_ data: Data, suggestedName: String? = nil, fileExtension: String = "png") throws -> URL {
        let itemDirectory = shelfDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: itemDirectory, withIntermediateDirectories: true)

        let fileName: String
        if let suggested = suggestedName, !suggested.isEmpty {
            let ext = (suggested as NSString).pathExtension
            fileName = ext.isEmpty ? "\(suggested).\(fileExtension)" : suggested
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd 'at' HH.mm.ss"
            let dateStr = formatter.string(from: Date())
            fileName = "Screenshot \(dateStr).\(fileExtension)"
        }

        let destinationURL = itemDirectory.appendingPathComponent(fileName)
        try data.write(to: destinationURL, options: .atomic)
        return destinationURL
    }

    /// Renames a stored file inside its isolated shelf item folder.
    func renameStoredFile(at currentURL: URL, to newName: String) throws -> URL {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return currentURL }

        let currentExtension = currentURL.pathExtension
        let finalFileName: String = if !currentExtension.isEmpty, (trimmed as NSString).pathExtension.isEmpty {
            "\(trimmed).\(currentExtension)"
        } else {
            trimmed
        }

        let destinationURL = currentURL.deletingLastPathComponent().appendingPathComponent(finalFileName)
        if destinationURL.path == currentURL.path {
            return currentURL
        }

        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }

        if fileManager.fileExists(atPath: currentURL.path) {
            try fileManager.moveItem(at: currentURL, to: destinationURL)
        }

        return destinationURL
    }

    /// Stores multiple files into a packaged directory inside the Shelf persistent storage.
    func storeGroup(urls: [URL], groupID: UUID, folderName: String) throws -> (folderURL: URL, storedFiles: [URL]) {
        let groupBase = shelfDirectory.appendingPathComponent(groupID.uuidString, isDirectory: true)
        let sanitized = sanitizeFolderName(folderName)
        let folderURL = groupBase.appendingPathComponent(sanitized, isDirectory: true)

        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

        var storedURLs: [URL] = []
        for src in urls {
            let isScoped = src.startAccessingSecurityScopedResource()
            defer {
                if isScoped {
                    src.stopAccessingSecurityScopedResource()
                }
            }

            let destination = folderURL.appendingPathComponent(src.lastPathComponent)
            if Darwin.clonefile(src.path, destination.path, 0) == 0 {
                storedURLs.append(destination)
            } else {
                try fileManager.copyItem(at: src, to: destination)
                storedURLs.append(destination)
            }
        }

        if let firstURL = storedURLs.first {
            cacheThumbnail(for: firstURL, in: folderURL)
        }

        return (folderURL, storedURLs)
    }

    /// Renames a stored folder inside its parent group directory.
    func renameStoredFolder(currentFolderURL: URL, to newFolderName: String) throws -> URL {
        let trimmed = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return currentFolderURL }

        let sanitized = sanitizeFolderName(trimmed)
        let parentDir = currentFolderURL.deletingLastPathComponent()
        let destinationURL = parentDir.appendingPathComponent(sanitized, isDirectory: true)

        if destinationURL.path == currentFolderURL.path {
            return currentFolderURL
        }

        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }

        try fileManager.moveItem(at: currentFolderURL, to: destinationURL)
        return destinationURL
    }

    /// Packages existing files into a named folder inside the group's storage directory.
    func packageExistingFiles(fileURLs: [URL], intoFolderNamed folderName: String, groupID: UUID) throws -> (folderURL: URL, updatedURLs: [URL]) {
        let groupBase = shelfDirectory.appendingPathComponent(groupID.uuidString, isDirectory: true)
        let sanitized = sanitizeFolderName(folderName)
        let folderURL = groupBase.appendingPathComponent(sanitized, isDirectory: true)

        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

        var updatedURLs: [URL] = []
        for fileURL in fileURLs {
            let destination = folderURL.appendingPathComponent(fileURL.lastPathComponent)
            if fileURL.path != destination.path {
                if fileManager.fileExists(atPath: destination.path) {
                    try? fileManager.removeItem(at: destination)
                }
                try fileManager.moveItem(at: fileURL, to: destination)
            }
            updatedURLs.append(destination)
        }

        return (folderURL, updatedURLs)
    }

    private func sanitizeFolderName(_ name: String) -> String {
        name.replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Deletes a stored file or folder and its parent container folder in the shelf directory.
    func removeStoredItem(at url: URL) {
        guard url.path.hasPrefix(shelfDirectory.path) else { return }

        let relative = url.path.replacingOccurrences(of: shelfDirectory.path, with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = relative.split(separator: "/")
        if let topGroupID = components.first {
            let topGroupDir = shelfDirectory.appendingPathComponent(String(topGroupID), isDirectory: true)
            try? fileManager.removeItem(at: topGroupDir)
        } else {
            try? fileManager.removeItem(at: url)
        }
    }
}
