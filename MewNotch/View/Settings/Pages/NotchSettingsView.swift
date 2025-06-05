//
//  NotchSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct NotchSettingsView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @State var screens: [NSScreen] = []
    
    func refreshNSScreens() {
        withAnimation {
            self.screens = NSScreen.screens
        }
    }
    
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
                                        self.refreshNSScreens()
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
                                            self.screens,
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
                                                if notchDefaults.shownOnDisplay[screen.localizedName] == true {
                                                    Color.gray.opacity(0.5)
                                                } else {
                                                    Color.gray.opacity(0.1)
                                                }
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
                        Text("Show on Lock Screen")
                    }
                    .onChange(
                        of: notchDefaults.shownOnLockScreen
                    ) {
                        // Kill All Notch to move existing notches out of Lock Screen Space
                        NotchManager.shared.refreshNotches(
                            killAllWindows: true
                        )
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
                            Text(
                                NotchHeightMode.Match_Notch.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                NotchHeightMode.Match_Notch
                            )
                            
                            Text(
                                NotchHeightMode.Match_Menu_Bar.rawValue.replacingOccurrences(
                                    of: "_",
                                    with: " "
                                )
                            )
                            .tag(
                                NotchHeightMode.Match_Menu_Bar
                            )
                        }
                    ) {
                        Text("Height")
                    }
                },
                header: {
                    Text("Interface")
                }
            )
            
            Section(
                content: {
                    Toggle(
                        isOn: $notchDefaults.expandOnHover
                    ) {
                        VStack(
                            alignment: .leading
                        ) {
                            Text("Expand on Hover")
                            
                            Text("Expand notch when hovered for more than 500ms.\nDisables click interactions in all HUDs")
                                .font(.footnote)
                        }
                    }
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
        ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) {
            NotchManager.shared.refreshNotches()
        }
        .onChange(
            of: scenePhase
        ) {
            self.refreshNSScreens()
        }
        .onAppear {
            self.refreshNSScreens()
        }
    }
}

#Preview {
    NotchSettingsView()
}
