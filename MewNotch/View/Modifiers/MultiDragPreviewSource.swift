//
//  MultiDragPreviewSource.swift
//  MewNotch
//
//  Created by Monu Kumar on 10/07/25.
//

import SwiftUI
import AppKit

struct DragSource: NSViewRepresentable {
    
    let items: () -> [NSPasteboardWriting]

    func makeCoordinator() -> Coordinator {
        Coordinator(
            items: items
        )
    }

    func makeNSView(
        context: Context
    ) -> NSView {
        let view = NSView(
            frame: .zero
        )
        
        let gesture = NSPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.beginDrag(_:))
        )
        
        view.addGestureRecognizer(gesture)
        
        return view
    }

    func updateNSView(
        _ nsView: NSView,
        context: Context
    ) {}

    class Coordinator: NSObject, NSDraggingSource {
        
        let items: () -> [NSPasteboardWriting]

        init(
            items: @escaping () -> [NSPasteboardWriting]
        ) {
            self.items = items
        }
        
        func draggingSession(
            _ session: NSDraggingSession,
            sourceOperationMaskFor context: NSDraggingContext
        ) -> NSDragOperation {
            return .copy
        }

        @objc func beginDrag(
            _ gesture: NSPanGestureRecognizer
        ) {
            guard gesture.state == .began,
                  let view = gesture.view,
                  let event = NSApp.currentEvent else {
                return
            }
            
            let draggingItems = items().map { item in
                let draggingItem = NSDraggingItem(
                    pasteboardWriter: item
                )
                
                let hostingView = NSHostingView(
                    rootView: EmptyView()
                )
                
                let size = hostingView.fittingSize
                hostingView.frame = CGRect(
                    origin: .zero,
                    size: size
                )
                
                let image = NSImage(
                    size: size
                )
                
                image.lockFocus()
                
                hostingView
                    .draw(
                        hostingView.bounds
                    )
                
                image
                    .unlockFocus()
                
                draggingItem
                    .setDraggingFrame(
                        CGRect(
                            origin: .zero,
                            size: size
                        ),
                        contents: image
                    )
                
                return draggingItem
            }
            
            view
                .beginDraggingSession(
                    with: draggingItems,
                    event: event,
                    source: self
                )
        }
    }
}
