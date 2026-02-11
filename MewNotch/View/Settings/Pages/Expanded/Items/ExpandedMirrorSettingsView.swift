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
                    subtitle: "Automatically activate camera when Expanded Notch opens",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $mirrorDefaults.autoStart)
                }
            } header: {
                Text("Behavior")
            }
            
            Section {
                HStack {
                    Spacer()
                    Toggle(notchDefaults.expandedNotchItems.contains(.Mirror) ? "Enabled" : "Disabled", isOn: Binding(
                        get: { notchDefaults.expandedNotchItems.contains(.Mirror) },
                        set: { _ in toggleMirror() }
                    ))
                    .toggleStyle(.switch)
                    .controlSize(.large)
                    Spacer()
                }
            }
        }
        .formStyle(.grouped)
    }
    
    private func toggleMirror() {
        if notchDefaults.expandedNotchItems.contains(.Mirror) {
            notchDefaults.expandedNotchItems.removeAll { $0 == .Mirror }
        } else {
            notchDefaults.expandedNotchItems.append(.Mirror)
            notchDefaults.expandedNotchItems.sort { a, b in
                let indexA = notchDefaults.expandedItemsOrder.firstIndex(of: a) ?? 0
                let indexB = notchDefaults.expandedItemsOrder.firstIndex(of: b) ?? 0
                return indexA < indexB
            }
        }
    }
}

#Preview {
    ExpandedMirrorSettingsView()
}
