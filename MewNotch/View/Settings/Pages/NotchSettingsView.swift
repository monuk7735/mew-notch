//
//  NotchSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI


struct NotchSettingsView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = NotchSettingsViewModel()
    
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var mirrorDefaults = MirrorDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Show Notch On",
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Picker("", selection: ~$notchDefaults.notchDisplayVisibility) {
                        ForEach(NotchDisplayVisibility.allCases) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                
                if notchDefaults.notchDisplayVisibility == .Custom {
                    VStack(spacing: 8) {
                        Text("Choose Displays to show notch on")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 12) {
                                ForEach(viewModel.screens, id: \.self) { screen in
                                    let isSelected = notchDefaults.shownOnDisplay[screen.localizedName] == true
                                    Text(screen.localizedName)
                                        .font(.subheadline)
                                        .frame(minHeight: 50)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(isSelected ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                                                .padding(1)
                                        )
                                        .onTapGesture {
                                            let old = notchDefaults.shownOnDisplay[screen.localizedName] ?? false
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                notchDefaults.shownOnDisplay[screen.localizedName] = !old
                                            }
                                        }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                SettingsRow(
                    title: "Show on Lock Screen",
                    subtitle: "Incompatible with File Shelf feature",
                    icon: MewNotch.Assets.icLock,
                    color: MewNotch.Colors.lock
                ) {
                    Toggle("", isOn: $notchDefaults.shownOnLockScreen)
                        .onChange(of: notchDefaults.shownOnLockScreen) { _, _ in
                            viewModel.refreshNotchesAndKillWindows()
                        }
                }
                
                SettingsRow(
                    title: "Hide on Full Screen",
                    subtitle: "Hides the notch when a full screen app is detected",
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.hideOnFullScreen)
                        .onChange(of: notchDefaults.hideOnFullScreen) { _, _ in
                            viewModel.refreshNotches()
                        }
                }
                
                SettingsRow(
                    title: "Reset View on Collapse",
                    subtitle: notchDefaults.resetViewOnCollapse ? "Notch resets to Home when Collapsed" : "Notch will retain state when Collapsed",
                    icon: MewNotch.Assets.icReset,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.resetViewOnCollapse)
                }
                
            } header: {
                Text("Displays")
            }
            
            Section {
                SettingsRow(
                    title: "Height",
                    icon: MewNotch.Assets.icHeight,
                    color: MewNotch.Colors.height
                ) {
                    Picker("", selection: $notchDefaults.heightMode) {
                        ForEach([NotchHeightMode.Match_Notch, NotchHeightMode.Match_Menu_Bar]) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                
                if #available(macOS 26.0, *) {
                    SettingsRow(
                        title: "Apply Glass Effect",
                        subtitle: "Forces 'Expand on Hover' to be enabled",
                        icon: MewNotch.Assets.icGlass,
                        color: MewNotch.Colors.glass
                    ) {
                        Toggle("", isOn: ~$notchDefaults.applyGlassEffect)
                    }
                }
            } header: {
                Text("Interface")
            }
            
            Section {
                SettingsRow(
                    title: "Expand on Hover",
                    subtitle: "Expand notch when hovered.\nDisables click interactions in all HUDs.",
                    icon: MewNotch.Assets.icHover,
                    color: MewNotch.Colors.hover
                ) {
                    Toggle("", isOn: Binding(
                        get: { notchDefaults.expandOnHover || notchDefaults.applyGlassEffect },
                        set: { newValue in
                            withAnimation {
                                notchDefaults.expandOnHover = newValue
                            }
                        }
                    ))
                }
                .disabled(notchDefaults.applyGlassEffect)
                
                SettingsRow(
                    title: "Hover Delay",
                    subtitle: "\(notchDefaults.expandOnHoverDelay.formatted()) seconds.\n",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Slider(
                        value: $notchDefaults.expandOnHoverDelay,
                        in: 0.1...2.0,
                        step: 0.1
                    )
                }
                .hide(when: !notchDefaults.expandOnHover && !notchDefaults.applyGlassEffect)

                SettingsRow(
                    title: "Haptic Feedback",
                    subtitle: "Play haptic feedback when hovering over the notch",
                    icon: MewNotch.Assets.icHaptic,
                    color: MewNotch.Colors.haptic
                ) {
                    Toggle("", isOn: $notchDefaults.hapticFeedback)
                }
            } header: {
                Text("Interaction")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Notch")
        .toolbarTitleDisplayMode(.inline)
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) { _, _ in
             viewModel.refreshNotches()
        }
    }
}

#Preview {
    NotchSettingsView()
}
