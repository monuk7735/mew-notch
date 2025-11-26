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
        self.overlay(DragSource(items: items))
    }
    
    func glassEffect(
        when enabled: Bool,
        in shape: any Shape
    ) -> some View {
        modifier(ConditionalLiquidGlass(enabled: enabled, shape: shape))
    }
}
