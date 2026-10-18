//
//  ExpandedBashSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/02/2026.
//

import SwiftUI

struct ExpandedBashSettingsView: View {
    @StateObject private var bashDefaults = BashDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Header Style",
                    subtitle: "Choose what to display at the top of the widget",
                    icon: .textAlignLeft,
                    color: AppColor.bashCommand
                ) {
                    Picker("", selection: ~$bashDefaults.headerStyle) {
                        ForEach(BashHeaderStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                }

                if bashDefaults.headerStyle == .title {
                    SettingsRow(
                        title: "Custom Title",
                        subtitle: "Label displayed in the widget header",
                        icon: .pencil,
                        color: AppColor.bashCommand
                    ) {
                        TextField("Title", text: $bashDefaults.title)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 160)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Command")
                        .font(.headline)

                    TextEditor(text: $bashDefaults.command)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 100)
                        .padding(4)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )

                    Text("Enter a bash command to execute. The output will be displayed in the notch.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Command & Header")
            }

            Section {
                SettingsRow(
                    title: "Text Alignment",
                    subtitle: "Alignment of the command output text",
                    icon: .textAlignLeft,
                    color: AppColor.bashCommand
                ) {
                    Picker("", selection: $bashDefaults.textAlignment) {
                        ForEach(BashTextAlignment.allCases) { alignment in
                            Text(alignment.displayName).tag(alignment)
                        }
                    }
                    .labelsHidden()
                }

                SettingsRow(
                    title: "Width Multiplier",
                    subtitle: bashDefaults.widthMultiplier.localizedMultiplierKey(),
                    icon: .textAlignLeft,
                    color: AppColor.bashCommand
                ) {
                    Slider(
                        value: $bashDefaults.widthMultiplier,
                        in: 0.5 ... 2.0,
                        step: 0.1
                    )
                }
            } header: {
                Text("Appearance")
            }

            Section {
                SettingsRow(
                    title: "Auto-Refresh",
                    subtitle: "Automatically execute the command periodically",
                    icon: .arrowClockwiseCircle,
                    color: AppColor.bashRefresh
                ) {
                    Toggle("", isOn: $bashDefaults.autoRefresh)
                }

                SettingsRow(
                    title: "Refresh Interval",
                    subtitle: bashDefaults.refreshInterval.localizedSecondsKey(width: .wide, maxFractionalDigits: 0),
                    icon: .clockArrowCirclepath,
                    color: AppColor.bashRefresh
                ) {
                    Slider(
                        value: $bashDefaults.refreshInterval,
                        in: 1.0 ... 10.0,
                        step: 1.0
                    )
                }
                .disabled(!bashDefaults.autoRefresh)
                .opacity(bashDefaults.autoRefresh ? 1.0 : 0.6)
            } header: {
                Text("Behavior")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedBashSettingsView()
}
