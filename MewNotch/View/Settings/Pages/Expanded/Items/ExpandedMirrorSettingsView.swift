//
//  MirrorSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct ExpandedMirrorSettingsView: View {
    
    @StateObject private var mirrorDefaults = MirrorDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Corner Radius",
                    subtitle: "Adjust the shape of the mirror",
                    icon: MewNotch.Assets.icCornerRadius,
                    color: MewNotch.Colors.mirror
                ) {
                    Slider(
                        value: $mirrorDefaults.cornerRadius,
                        in: 15...50,
                        step: 1
                    )
                }
            } header: {
                Text("Mirror Appearance")
            }
            
            Section {
                SettingsRow(
                    title: "Auto-Start Mirror",
                    subtitle: "Automatically activate camera when notch is expanded",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $mirrorDefaults.autoStart)
                }
            } header: {
                Text("Behavior")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedMirrorSettingsView()
}
