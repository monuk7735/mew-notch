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
        NotchControlButton(
            notchViewModel: notchViewModel,
            icon: "gear",
            isSelected: false,
            action: openSettings.callAsFunction
        )
    }
}
