//
//  View.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HiddenViewModifier: ViewModifier {
    var hidden: Bool

    func body(
        content: Content
    ) -> some View {
        if hidden {
            EmptyView()
        } else {
            content
        }
    }
}

struct ConditionalLiquidGlass: ViewModifier {
    var enabled: Bool
    var shape: any Shape

    func body(content: Content) -> some View {
        if #available(macOS 26.0, *), enabled {
            content.glassEffect(
                .regular.interactive(),
                in: shape
            )
        } else {
            content
        }
    }
}

extension View {
    func hide(
        when hidden: Bool
    ) -> some View {
        modifier(HiddenViewModifier(hidden: hidden))
    }

    func onMultiDrag(
        _ items: @escaping () -> [NSPasteboardWriting]
    ) -> some View {
        overlay(DragSource(items: items))
    }

    func glassEffect(
        when enabled: Bool,
        in shape: any Shape
    ) -> some View {
        modifier(ConditionalLiquidGlass(enabled: enabled, shape: shape))
    }

    @ViewBuilder
    func `if`(
        _ enabled: Bool,
        modifier: (Self) -> some View
    ) -> some View {
        if enabled {
            modifier(self)
        } else {
            self
        }
    }

    func resignKeyboardOnTapOutside() -> some View {
        modifier(ResignKeyboardOnTapOutsideModifier())
    }
}

struct ResignKeyboardOnTapOutsideModifier: ViewModifier {
    @State private var eventMonitor: Any?

    func body(content: Content) -> some View {
        content
            .onAppear {
                eventMonitor = NSEvent.addLocalMonitorForEvents(
                    matching: [.leftMouseDown, .rightMouseDown]
                ) { event in
                    guard let window = event.window,
                          let firstResponder = window.firstResponder as? NSView,
                          firstResponder is NSTextView || firstResponder is NSTextField else {
                        return event
                    }

                    let clickPoint = event.locationInWindow
                    if let hitView = window.contentView?.hitTest(clickPoint) {
                        let isInsideCurrentResponder = (hitView === firstResponder) ||
                            hitView.isDescendant(of: firstResponder) ||
                            firstResponder.isDescendant(of: hitView)
                        if !isInsideCurrentResponder {
                            window.makeFirstResponder(nil)
                        }
                    } else {
                        window.makeFirstResponder(nil)
                    }

                    return event
                }
            }
            .onDisappear {
                if let monitor = eventMonitor {
                    NSEvent.removeMonitor(monitor)
                    eventMonitor = nil
                }
            }
    }
}
