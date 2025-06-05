//
//  NotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class NotchViewModel: ObservableObject {
    
    var screen: NSScreen
    
    @Published var notchSize: CGSize = .zero
    
    var cornerRadius: (
        top: CGFloat,
        bottom: CGFloat
    ) = (
        top: 8,
        bottom: 13
    )
    
    var minimalHUDPadding: CGFloat = 0
    
    var extraNotchPadSize: CGSize = .init(
        width: 16,
        height: 0
    )
    
    @Published var isHovered: Bool = false
    @Published var isExpanded: Bool = false
    
    @Published var isPinned: Bool = false
    
    private var hoverTimer: Timer? = nil
    
    init(
        screen: NSScreen
    ) {
        self.screen = screen
        
        let shouldForce = NotchDefaults.shared.notchDisplayVisibility != .NotchedDisplayOnly
        
        self.notchSize = NotchUtils.shared.notchSize(
            screen: self.screen,
            force: shouldForce
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
            
            minimalHUDPadding = notchSize.height * 0.2
        }
    }
    
    func refreshNotchSize() {
        let shouldForce = NotchDefaults.shared.notchDisplayVisibility != .NotchedDisplayOnly
        
        self.notchSize = NotchUtils.shared.notchSize(
            screen: self.screen,
            force: shouldForce
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
            
            minimalHUDPadding = notchSize.height * 0.2
        }
    }
    
    func onHover(
        _ isHovered: Bool,
        shouldExpand: Bool = true
    ) {
        hoverTimer?.invalidate()
        
        if isHovered {
            if shouldExpand {
                hoverTimer = .scheduledTimer(
                    withTimeInterval: 0.4,
                    repeats: false
                ) { _ in
                    
                    HapticsManager.shared.feedback(
                        pattern: .generic
                    )
                    
                    self.onTap()
                }
            }
        } else if !isPinned {
            withAnimation {
                self.isExpanded = false
                
                self.cornerRadius = NotchUtils.shared.collapsedCornerRadius
                self.extraNotchPadSize = .init(
                    width: self.cornerRadius.top * 2,
                    height: 0
                )
            }
        }
        
        withAnimation {
            self.isHovered = isHovered
        }
    }
    
    func onTap() {
        withAnimation(
            .spring(
                .bouncy(
                    duration: 0.5,
                    extraBounce: 0.1
                )
            )
        ) {
            self.isExpanded = true
        }
        
        withAnimation {
            self.cornerRadius = NotchUtils.shared.expandedCornerRadius
            self.extraNotchPadSize = .init(
                width: self.cornerRadius.top * 2,
                height: 0
            )
        }
    }
}
