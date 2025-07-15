//
//  URL.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import QuickLook

extension URL {
    func previewImage() -> NSImage {
        if let preview = QLThumbnailImageCreate(
            kCFAllocatorDefault,
            self as CFURL,
            CGSize(
                width: 128,
                height: 128
            ),
            nil
        )?.takeRetainedValue() {
            return NSImage(
                cgImage: preview,
                size: .zero
            )
        }
        
        return NSWorkspace.shared
            .icon(
                forFile: path
            )
    }
}
