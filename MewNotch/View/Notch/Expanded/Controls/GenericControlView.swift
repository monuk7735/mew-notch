//
//  GenericControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/04/25.
//

import SwiftUI

struct GenericControlView<Content: View>: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var content: () -> Content
    
    var body: some View {
        content()
            .padding(notchViewModel.minimalHUDPadding * 1.5)
            .frame(
                width: notchViewModel.notchSize.height,
                height: notchViewModel.notchSize.height
            )
    }
}
