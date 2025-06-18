//
//  SettingsControlView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/04/25.
//

import SwiftUI

struct SettingsControlView: View {
    
    @Environment(\.openSettings) private var openSettings
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var body: some View {
        GenericControlView(
            notchViewModel: notchViewModel
        ) {
            Button(
                action: openSettings.callAsFunction
            ) {
                Image(
                    systemName: "gear.circle.fill"
                )
                .resizable()
                .scaledToFit()
            }
            .buttonStyle(.plain)
        }
    }
}
