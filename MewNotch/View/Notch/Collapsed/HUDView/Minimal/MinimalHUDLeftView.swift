//
//  MinimalHUDLeftView.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/03/25.
//

import SwiftUI

struct MinimalHUDLeftView<T: HUDDefaultsProtocol>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults: T
    
    var hudModel: HUDPropertyModel?
    
    var body: some View {
        if let hud = hudModel, defaults.isEnabled, (defaults.style == .Minimal || notchViewModel.isExpanded) {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .left
            ) {
                hud.getIcon()
            }
        }
    }
}
