//
//  ShelfFileGroupModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import Foundation

struct ShelfFileModel: Identifiable, Codable {
    let id: UUID
    
    let fileURL: URL
    let bookmarkData: Data
    
    let fileName: String
    
    // Non-Codable properties
    let preview: NSImage
    let itemProvider: NSItemProvider
    
    let addedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, bookmarkData, fileName, addedAt
    }
    
    init?(
        url: URL
    ) {
        // Create security-scoped bookmark
        do {
            let data = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            self.bookmarkData = data
        } catch {
            print("Failed to create bookmark for \(url): \(error)")
            return nil
        }
        
        self.id = UUID()
        self.fileURL = url
        self.fileName = url.lastPathComponent
        self.preview = url.previewImage()
        
        self.itemProvider = .init(contentsOf: url) ?? .init()
        self.itemProvider.suggestedName = (self.fileName as NSString).deletingPathExtension
        
        self.addedAt = .now
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        fileName = try container.decode(String.self, forKey: .fileName)
        addedAt = try container.decode(Date.self, forKey: .addedAt)
        bookmarkData = try container.decode(Data.self, forKey: .bookmarkData)
        
        // Resolve bookmark
        var isStale = false
        do {
            let resolvedURL = try URL(
                resolvingBookmarkData: bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            if isStale {
                // In a real app we might want to update the bookmark, 
                // but for now we just use the resolved URL
                print("Bookmark is stale for \(fileName)")
            }
            
            // Start accessing the security scoped resource
            if resolvedURL.startAccessingSecurityScopedResource() {
                // We keep accessing it? Or stop? 
                // Usually we need to access it when using it. 
                // For simplicity in this Shelf context, we might rely on the fact 
                // that Finder/User granted access or standard file access works.
                // However, correct pattern is to stop accessing when done.
                // But for `previewImage` and `itemProvider` to work immediately, we access now.
                // NOTE: ItemProvider might need re-access later.
                resolvedURL.stopAccessingSecurityScopedResource()
            }
             
            self.fileURL = resolvedURL
            self.preview = resolvedURL.previewImage()
            self.itemProvider = .init(contentsOf: resolvedURL) ?? .init()
            self.itemProvider.suggestedName = (self.fileName as NSString).deletingPathExtension
            
        } catch {
            throw DecodingError.dataCorruptedError(
                forKey: .bookmarkData,
                in: container,
                debugDescription: "Failed to resolve bookmark: \(error)"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(addedAt, forKey: .addedAt)
        try container.encode(bookmarkData, forKey: .bookmarkData)
    }
}

struct ShelfFileGroupModel: Identifiable, Codable {
    let id: UUID
    
    let files: [ShelfFileModel]
    let groupName: String
    
    // Ignored
    let preview: NSImage
    
    enum CodingKeys: String, CodingKey {
        case id, files, groupName
    }
    
    init?(
        urls: [URL]
    ) {
        guard !urls.isEmpty else {
            return nil
        }
        
        // Compact map because ShelfFileModel init is now failable (bookmark creation)
        let files = urls.compactMap {
            ShelfFileModel(
                url: $0
            )
        }
        
        guard !files.isEmpty else { return nil }
        
        self.id = .init()
        self.files = files
        
        guard let firstFile = self.files.first else {
            return nil
        }
        
        self.groupName = firstFile.fileName + (
            files.count > 1 ? " + \(files.count - 1) more" : ""
        )
        
        self.preview = firstFile.preview
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        files = try container.decode([ShelfFileModel].self, forKey: .files)
        groupName = try container.decode(String.self, forKey: .groupName)
        
        // Re-generate preview
        if let firstFile = files.first {
            preview = firstFile.preview
        } else {
            // Should not happen if data is valid, but fallback
            preview = NSImage(systemSymbolName: "doc", accessibilityDescription: nil) ?? NSImage()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(files, forKey: .files)
        try container.encode(groupName, forKey: .groupName)
    }
}
