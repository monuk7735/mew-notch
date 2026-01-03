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
        VStack(spacing: 24) {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
            
            VStack(spacing: 8) {
                Text("MewNotch")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Version \(updaterViewModel.currentVersion)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Button("Check for Updates") {
                updaterViewModel.checkForUpdates()
            }
            .disabled(!updaterViewModel.canCheckForUpdates)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Remove standard form styling since we are doing custom layout
        // .formStyle(.grouped) 
        .navigationTitle("About")
    }
}

#Preview {
    AboutAppView()
}
