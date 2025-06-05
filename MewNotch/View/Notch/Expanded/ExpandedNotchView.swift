//
//  ExpandedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct ExpandedNotchView: View {
    
    var namespace: Namespace.ID
    
    @Namespace private var nilNamespace
    
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var collapsedNotchView: CollapsedNotchView
    
    @StateObject private var expandedNotchViewModel: ExpandedNotchViewModel = .init()
    
    var body: some View {
        VStack {
            HStack {
                SettingsControlView(
                    notchViewModel: notchViewModel
                )
                
                collapsedNotchView
                .opacity(0)
                .disabled(true)
                
                PinControlView(
                    notchViewModel: notchViewModel
                )
            }
            
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
                        .id(notchViewModel.isExpanded)
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
        .padding(
            .init(
                top: 0,
                leading: 8 + notchViewModel.extraNotchPadSize.width / 2,
                bottom: 8,
                trailing: 8 + notchViewModel.extraNotchPadSize.width / 2
            )
        )
        .offset(
            y: notchViewModel.isExpanded ? 0 : -notchViewModel.notchSize.height * 3
        )
        .frame(
            width: notchViewModel.isExpanded ? nil : 0,
            height: notchViewModel.isExpanded ? nil : 0
        )
        .opacity(notchViewModel.isExpanded ? 1 : 0)
    }
}
