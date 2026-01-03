//
//  AboutAppView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct AboutAppView: View {
    
    @StateObject var updaterViewModel = UpdaterViewModel.shared
    
    var body: some View {
        VStack(spacing: 32) {
            
            VStack(spacing: 16) {

                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(radius: 10)
                
                VStack(spacing: 8) {
                    Text("MewNotch")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(MewNotch.Colors.notch.color)
                    
                    Text("Version \(updaterViewModel.currentVersion)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background {
                            Capsule()
                                .fill(.tertiary.opacity(0.2))
                        }
                }
            }

            VStack(spacing: 16) {
                Button(action: {
                    updaterViewModel.checkForUpdates()
                }) {
                    Text("Check for Updates")
                        .font(.system(size: 13, weight: .medium))
                        .frame(maxWidth: 160)
                }
                .controlSize(.large)
                .disabled(!updaterViewModel.canCheckForUpdates)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
    }
}

#Preview {
    AboutAppView()
}
