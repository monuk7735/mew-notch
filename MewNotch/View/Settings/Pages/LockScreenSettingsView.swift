//
//  LockScreenSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 18/10/26.
//

import SwiftUI

struct LockScreenSettingsView: View {
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Show on Lock Screen",
                    subtitle: "Displays the notch on the lock screen",
                    icon: .lock,
                    color: AppColor.lock
                ) {
                    Toggle("", isOn: $notchDefaults.shownOnLockScreen)
                        .onChange(of: notchDefaults.shownOnLockScreen) { _, _ in
                            NotchManager.shared.refreshNotches(killAllWindows: true)
                        }
                }
            } header: {
                Text("Lock Screen")
            }
        }
        .formStyle(.grouped)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .navigationTitle("Lock Screen")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    LockScreenSettingsView()
}
