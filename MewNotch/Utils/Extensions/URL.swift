//
//  URL.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import AppKit
import QuickLook

extension URL {
    func previewImage() -> NSImage {
        let imageExtensions: Set = [
            "png", "jpg", "jpeg", "heic", "heif",
            "tiff", "tif", "gif", "webp", "bmp", "ico", "icns"
        ]

        // Fast path: If it's an image, load directly from disk without QuickLook IPC
        if imageExtensions.contains(pathExtension.lowercased()),
           let image = NSImage(contentsOf: self) {
            return image
        }

        // Fast path: Check for cached thumbnail file in the item folder
        let thumbnailURL = deletingLastPathComponent().appendingPathComponent("thumbnail.png")
        if FileManager.default.fileExists(atPath: thumbnailURL.path),
           let cachedImage = NSImage(contentsOf: thumbnailURL) {
            return cachedImage
        }

        let parentThumbnailURL = deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("thumbnail.png")
        if FileManager.default.fileExists(atPath: parentThumbnailURL.path),
           let cachedImage = NSImage(contentsOf: parentThumbnailURL) {
            return cachedImage
        }

        // Avoid synchronous QuickLook IPC on the main thread to prevent priority inversion and hang risk
        if !Thread.isMainThread {
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
        }

        // Fast, non-blocking fallback using system icon
        return NSWorkspace.shared.icon(forFile: path)
    }
}
