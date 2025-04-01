//
//  NotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

struct NotchView: View {
    
    @Namespace var namespace
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @StateObject var notchViewModel: NotchViewModel
    
    @State var isExpanded: Bool = false
    
    init(
        screen: NSScreen
    ) {
        self._notchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack(
                    alignment: .top
                ) {
                    ExpandedNotchView(
                        namespace: namespace,
                        notchViewModel: notchViewModel
                    )
                    
                    CollapsedNotchView(
                        namespace: namespace,
                        notchViewModel: notchViewModel
                    )
                }
                .background {
                    Color.black
                }
                .mask {
                    NotchShape(
                        topRadius: notchViewModel.cornerRadius.top,
                        bottomRadius: notchViewModel.cornerRadius.bottom
                    )
                }
                .scaleEffect(
                    notchViewModel.isHovered ? 1.05 : 1.0,
                    anchor: .top
                )
                .shadow(
                    radius: notchViewModel.isHovered ? 5 : 0
                )
                .onHover {
                    notchViewModel.onHover(
                        $0,
                        shouldExpand: notchDefaults.expandOnHover
                    )
                }
                .onTapGesture(
                    perform: notchViewModel.onTap
                )
                
                Spacer()
            }
            
            Spacer()
        }
        .preferredColorScheme(.dark)
        .contextMenu(
            menuItems: {
                
                Button("Settings") {
                    /// Restarting app instead of calling `openSettings()` helps bring the window forward
                    AppManager.shared.restartApp(
                        killPreviousInstance: false
                    )
                }
                .keyboardShortcut(
                    ",",
                    modifiers: .command
                )
                
                Button("Restart") {
                    AppManager.shared.restartApp(
                        killPreviousInstance: true
                    )
                }
                .keyboardShortcut("R", modifiers: .command)
            }
        )
    }
}

#Preview {
    NotchView(
        screen: .main!
    )
}
