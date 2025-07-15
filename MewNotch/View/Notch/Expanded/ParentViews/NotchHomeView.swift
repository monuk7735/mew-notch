//
//  NotchHomeView.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import SwiftUI

struct NotchHomeView: View {
    
    var namespace: Namespace.ID
    
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    var collapsedNotchView: CollapsedNotchView
    
    var body: some View {
        HStack(
            spacing: 12
        ) {
            let items = Array(
                notchDefaults.expandedNotchItems.sorted {
                    $0.rawValue < $1.rawValue
                }
            )
            
            ForEach(
                0..<items.count,
                id: \.self
            ) { index in
                
                let item = items[index]
                
                switch item {
                case .Mirror:
                    MirrorView(
                        notchViewModel: notchViewModel
                    )
                case .NowPlaying:
                    NowPlayingDetailView(
                        namespace: namespace,
                        notchViewModel: notchViewModel,
                        nowPlayingModel: expandedNotchViewModel.nowPlayingMedia ?? .Placeholder
                    )
                }
                
                if notchDefaults.showDividers && index != items.count - 1 {
                    Divider()
                }
            }
            
        }
        .frame(
            height: notchViewModel.notchSize.height * 3
        )
    }
}
