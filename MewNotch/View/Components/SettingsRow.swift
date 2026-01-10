//
//  SettingsRow.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI


struct SettingsIcon: View {
    let icon: Image
    let color: MewNotch.IconColor
    
    @ScaledMetric private var iconSize: CGFloat = 30 // Reverted to 30
    @ScaledMetric private var cornerRadius: CGFloat = 7 // Reverted to 7
    
    var body: some View {
        icon
            .font(.headline) // Reverted from .title3
            .foregroundStyle(.white)
            .frame(width: iconSize, height: iconSize)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color.color.gradient)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            )
    }
}

struct SettingsRow<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: Image
    let color: MewNotch.IconColor
    let content: Content
    
    @ScaledMetric private var spacing: CGFloat = 16
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: Image,
        color: MewNotch.IconColor,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            SettingsIcon(icon: icon, color: color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3) // Increased to .title3
                    .fontWeight(.medium) // Slightly bolder for title feel
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.body) // Increased to .body
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
            
            content
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }
}

// Convenience init for no content (just label)
extension SettingsRow where Content == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        icon: Image,
        color: MewNotch.IconColor
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.content = EmptyView()
    }
}

#Preview {
    List {
        SettingsRow(
            title: "General Settings",
            subtitle: "Takes you to general settings",
            icon: Image(systemName: "gear"),
            color: .gray
        )
        
        SettingsRow(
            title: "Enabled",
            icon: Image(systemName: "bolt.fill"),
            color: .green
        ) {
            Toggle("", isOn: .constant(true))
        }
        
        SettingsRow(
            title: "Appearance",
            icon: Image(systemName: "paintpalette.fill"),
            color: .blue
        ) {
            Picker("", selection: .constant(1)) {
                Text("Dark").tag(0)
                Text("Light").tag(1)
            }
        }
    }
}
