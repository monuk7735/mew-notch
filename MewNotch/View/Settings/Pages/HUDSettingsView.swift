//
//  HUDSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct HUDSettingsView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                HudTabButton(title: "Audio", icon: MewNotch.Assets.icAudio, tag: 0, selection: $selectedTab)
                HudTabButton(title: "Brightness", icon: MewNotch.Assets.icBrightnessFill, tag: 1, selection: $selectedTab)
                HudTabButton(title: "Power", icon: MewNotch.Assets.icPower, tag: 2, selection: $selectedTab)
                HudTabButton(title: "Media", icon: MewNotch.Assets.icMedia, tag: 3, selection: $selectedTab)
            }
            .padding()
            
            Group {
                switch selectedTab {
                case 0:
                    HUDAudioSettingsView()
                case 1:
                    HUDBrightnessSettingsView()
                case 2:
                    HUDPowerSettingsView()
                case 3:
                    HUDMediaSettingsView()
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("HUDs")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    HUDSettingsView()
}

struct HudTabButton: View {
    let title: String
    let icon: Image
    let tag: Int
    @Binding var selection: Int
    
    var isSelected: Bool { selection == tag }
    
    var body: some View {
        Button {
            withAnimation(.snappy(duration: 0.2)) {
                selection = tag
            }
        } label: {
            VStack(spacing: 8) {
                icon
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? .white : .secondary)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
}
