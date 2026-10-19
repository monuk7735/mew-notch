//
//  ExternalDisplaySettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct ExternalDisplaySettingsView: View {
    @StateObject var notchDefaults = NotchDefaults.shared

    private var floatingIslandHeightSubtitle: LocalizedStringKey {
        let offset = Int(notchDefaults.floatingIslandHeightOffset)
        if offset == 0 {
            return "Default"
        } else if offset > 0 {
            return "+\(offset) pt"
        } else {
            return "\(offset) pt"
        }
    }

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Notch Style",
                    subtitle: notchDefaults.externalNotchStyle.description,
                    icon: .display,
                    color: AppColor.notch
                ) {
                    Picker("", selection: $notchDefaults.externalNotchStyle) {
                        ForEach(ExternalNotchStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                    .onChange(of: notchDefaults.externalNotchStyle) { _, _ in
                        NotchManager.shared.refreshNotches(killAllWindows: true)
                    }
                }
            } header: {
                Text("Notch Style")
            }

            if notchDefaults.externalNotchStyle == .hud {
                Section {
                    SettingsRow(
                        title: "Top Offset",
                        subtitle: "\(Int(notchDefaults.externalHUDTopOffset)) pt",
                        icon: .arrowUp,
                        color: AppColor.notch
                    ) {
                        Slider(
                            value: $notchDefaults.externalHUDTopOffset,
                            in: 0.0 ... 60.0,
                            step: 1.0
                        )
                    }
                } header: {
                    Text("HUD Position")
                }
            }

            if notchDefaults.externalNotchStyle == .island {
                Section {
                    SettingsRow(
                        title: "Top Offset",
                        subtitle: "\(Int(notchDefaults.floatingIslandTopOffset)) pt",
                        icon: .arrowUp,
                        color: AppColor.notch
                    ) {
                        Slider(
                            value: $notchDefaults.floatingIslandTopOffset,
                            in: 0.0 ... 60.0,
                            step: 1.0
                        )
                    }

                    SettingsRow(
                        title: "Width",
                        subtitle: "\(Int(notchDefaults.floatingIslandWidth)) pt",
                        icon: .arrowLeftAndRight,
                        color: AppColor.notch
                    ) {
                        Slider(
                            value: $notchDefaults.floatingIslandWidth,
                            in: 120.0 ... 320.0,
                            step: 2.0
                        )
                    }

                    SettingsRow(
                        title: "Height Adjustment",
                        subtitle: floatingIslandHeightSubtitle,
                        icon: .arrowUpAndDown,
                        color: AppColor.notch
                    ) {
                        Slider(
                            value: $notchDefaults.floatingIslandHeightOffset,
                            in: -10.0 ... 30.0,
                            step: 1.0
                        )
                    }
                } header: {
                    Text("Island Position & Size")
                }
            }

            Section {
                SettingsRow(
                    title: "Brightness Control",
                    subtitle: "Let BetterDisplay handle brightness keys",
                    icon: .brightnessFill,
                    color: AppColor.brightness
                ) {
                    Toggle("", isOn: $notchDefaults.yieldBrightnessToBetterDisplay)
                }

                SettingsRow(
                    title: "Status",
                    subtitle: "Detects running application",
                    icon: .statusIcon,
                    color: AppColor.general
                ) {
                    let isRunning = BetterDisplayManager.shared.isBetterDisplayRunning
                    HStack(spacing: 6) {
                        Circle()
                            .fill(isRunning ? Color.green : Color.secondary)
                            .frame(width: 8, height: 8)
                        Text(isRunning ? "Running" : "Not Detected")
                            .font(.subheadline)
                            .foregroundStyle(isRunning ? .primary : .secondary)
                    }
                }
            } header: {
                Text("BetterDisplay")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("External Display")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ExternalDisplaySettingsView()
}
