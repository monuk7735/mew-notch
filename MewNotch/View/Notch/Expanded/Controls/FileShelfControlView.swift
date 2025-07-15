//
//  FileShelfControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//

import SwiftUI

struct FileShelfControlView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var body: some View {
        GenericControlView(
            notchViewModel: notchViewModel
        ) {
            Button(
                action: {
                    withAnimation {
                        let oldView = expandedNotchViewModel.currentView
                        expandedNotchViewModel.currentView = oldView == .Shelf ? .Home : .Shelf
                    }
                }
            ) {
                Image(
                    systemName: "document.circle.fill"
                )
                .resizable()
                .scaledToFit()
            }
            .buttonStyle(.plain)
        }
    }
}
