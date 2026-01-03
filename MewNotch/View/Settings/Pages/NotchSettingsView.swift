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
    
    var body: some View {
        Form {
            Section(
                content: {
                    Picker(
                        selection: $notchDefaults.notchDisplayVisibility,
                        content: {
                            ForEach(
                                NotchDisplayVisibility.allCases
                            ) { item in
                                Text(item.displayName)
                                .tag(item)
                            }
                        }
                    ) {
                        Text("Show Notch On")
                    }
                    
                    if notchDefaults.notchDisplayVisibility == .Custom {
                        VStack {
                            HStack {
                                Text("Choose Displays to show notch on")
                                Spacer()
                                Button(
                                    action: {
                                        viewModel.refreshNSScreens()
                                    }
                                ) {
                                    Text("Refresh List")
                                }
                            }
                            
                            HStack {
                                ScrollView(
                                    .horizontal
                                ) {
                                    LazyHStack(
                                        spacing: 16
                                    ) {
                                        ForEach(
                                            viewModel.screens,
                                            id: \.self
                                        ) { screen in
                                            Text(
                                                screen.localizedName
                                            )
                                            .padding(16)
                                            .frame(
                                                minHeight: 100
                                            )
                                            .background {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(
                                                        notchDefaults.shownOnDisplay[screen.localizedName] == true
                                                        ? Color.accentColor.opacity(0.2)
                                                        : Color.clear
                                                    )
                                            }
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(
                                                        notchDefaults.shownOnDisplay[screen.localizedName] == true
                                                        ? Color.accentColor
                                                        : Color.gray.opacity(0.2),
                                                        lineWidth: 2
                                                    )
                                            }
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 16
                                                )
                                            )
                                            .onTapGesture {
                                                let oldValue = notchDefaults.shownOnDisplay[screen.localizedName] ?? false
                                                
                                                withAnimation {
                                                    notchDefaults.shownOnDisplay[screen.localizedName] = !oldValue
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Toggle(
                        isOn: $notchDefaults.shownOnLockScreen
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Show on Lock Screen")
                            
                            Text("Incompatible with File Shelf feature")
                                .font(.footnote)
                        }
                        
                    }
                    .onChange(
                        of: notchDefaults.shownOnLockScreen
                    ) { _, _ in
                        viewModel.refreshNotchesAndKillWindows()
                    }
                    
                    Toggle(
                        isOn: $notchDefaults.resetViewOnCollapse
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Reset Selected View on Collapse")
                            
                            if notchDefaults.resetViewOnCollapse {
                                Text("Notch resets to Home when Collapsed")
                                    .font(.footnote)
                            } else {
                                Text("Notch will retain state when Collapsed")
                                    .font(.footnote)
                            }
                        }
                    }
                    .onChange(
                        of: notchDefaults.shownOnLockScreen
                    ) { _, _ in
                        viewModel.refreshNotchesAndKillWindows()
                    }
                },
                header: {
                    Text("Displays")
                }
            )
            
            Section(
                content: {
                    Picker(
                        selection: $notchDefaults.heightMode,
                        content: {
                            ForEach(
                                NotchHeightMode.allCases
                            ) { item in
                                Text(item.displayName)
                                .tag(item)
                            }
                        }
                    ) {
                        Text("Height")
                    }
                    
                    if #available(macOS 26.0, *) {
                        Toggle(isOn: $notchDefaults.applyGlassEffect) {
                            VStack(
                                alignment: .leading
                            ) {
                                Text("Apply glass effect")
                                
                                (Text("Forces ") + Text("Expand on Hover").bold() + Text(" to be enabled"))
                                    .font(.footnote)
                            }
                        }
                    }
                },
                header: {
                    Text("Interface")
                }
            )
            
            Section(
                content: {
                    Toggle(
                        isOn: .init(
                            get: { notchDefaults.expandOnHover || notchDefaults.applyGlassEffect },
                            set: {
                                notchDefaults.expandOnHover = $0
                            }
                        )
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Expand on Hover")
                            
                            Text("Expand notch when hovered for more than 500ms.\nDisables click interactions in all HUDs")
                                .font(.footnote)
                        }
                    }
                    .disabled(notchDefaults.applyGlassEffect)
                },
                header: {
                    Text("Interaction")
                }
            )
            
            Section(
                content: {
                    Toggle(
                        isOn: $notchDefaults.showDividers
                    ) {
                        Text("Separator between Items")
                    }
                },
                header: {
                    Text("Expanded Notch")
                }
            )
            
            Section(
                content: {
                    ForEach(
                        ExpandedNotchItem.allCases
                    ) { item in
                        Toggle(
                            isOn: .init(
                                get: { notchDefaults.expandedNotchItems.contains(item) },
                                set: { isEnabled in
                                    if isEnabled {
                                        notchDefaults.expandedNotchItems.insert(item)
                                    } else {
                                        notchDefaults.expandedNotchItems.remove(item)
                                    }
                                }
                            )
                        ) {
                            Text(item.displayName)
                        }
                    }
                },
                header: {
                    Text("Expanded Notch Items")
                }
            )
        }
        .formStyle(.grouped)
        .navigationTitle("Notch")
        .toolbarTitleDisplayMode(.inline)
        .onChange(
            of: notchDefaults.notchDisplayVisibility
        ) { _, _ in
             viewModel.refreshNotches()
        }
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) { _, _ in
             viewModel.refreshNotches()
        }
        .onChange(
             of: scenePhase
        ) { _, _ in
             viewModel.refreshNSScreens()
        }
        .onAppear {
             viewModel.refreshNSScreens()
        }
    }
}

#Preview {
    NotchSettingsView()
}
