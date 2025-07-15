//
//  ShelfFileGroupModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import Foundation

struct ShelfFileModel: Identifiable {
    let id: UUID
    
    let fileURL: URL
    
    let fileName: String
    let preview: NSImage
    
    let itemProvider: NSItemProvider
    let addedAt: Date
    
    init(
        url: URL
    ) {
        id = UUID()
        
        fileURL = url
        
        fileName = url.lastPathComponent
        preview = url.previewImage()
        
        itemProvider = .init(
            contentsOf: url
        ) ?? .init()
        addedAt = .now
        
        self.itemProvider.suggestedName = (fileName as NSString).deletingPathExtension
    }
}

struct ShelfFileGroupModel: Identifiable {
    let id: UUID
    
    let files: [ShelfFileModel]
    let groupName: String
    let preview: NSImage
    
    init?(
        urls: [URL]
    ) {
        guard !urls.isEmpty else {
            return nil
        }
        
        let files = urls.map {
            ShelfFileModel(
                url: $0
            )
        }
        
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
}
