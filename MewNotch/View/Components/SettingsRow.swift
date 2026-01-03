//
//  SettingsRow.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI


enum SettingsIconColor: String {
    case blue
    case red
    case green
    case orange
    case yellow
    case pink
    case purple
    case gray
    case cyan
    case indigo
    case teal
    
    var color: Color {
        switch self {
        case .blue: return Color(red: 0.298, green: 0.686, blue: 0.969)  // Soft Blue
        case .red: return Color(red: 1.0, green: 0.498, blue: 0.498)     // Soft Red
        case .green: return Color(red: 0.353, green: 0.824, blue: 0.588) // Soft Green
        case .orange: return Color(red: 1.0, green: 0.698, blue: 0.4)    // Soft Orange
        case .yellow: return Color(red: 1.0, green: 0.843, blue: 0.0)    // Soft Yellow (Gold)
        case .pink: return Color(red: 1.0, green: 0.627, blue: 0.784)    // Soft Pink
        case .purple: return Color(red: 0.725, green: 0.518, blue: 0.933)// Soft Purple
        case .gray: return Color(red: 0.663, green: 0.663, blue: 0.663)  // Soft Gray
        case .cyan: return Color(red: 0.4, green: 0.9, blue: 0.95)       // Soft Cyan
        case .indigo: return Color(red: 0.45, green: 0.5, blue: 0.85)    // Soft Indigo
        case .teal: return Color(red: 0.4, green: 0.8, blue: 0.8)        // Soft Teal
        }
    }
}

struct SettingsIcon: View {
    let icon: String
    let color: SettingsIconColor
    
    @ScaledMetric private var iconSize: CGFloat = 30 // Reverted to 30
    @ScaledMetric private var cornerRadius: CGFloat = 7 // Reverted to 7
    
    var body: some View {
        Image(systemName: icon)
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
    let icon: String
    let color: SettingsIconColor
    let content: Content
    
    @ScaledMetric private var spacing: CGFloat = 16
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: SettingsIconColor,
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
    }
}

// Convenience init for no content (just label)
extension SettingsRow where Content == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: SettingsIconColor
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
            icon: "gear",
            color: .gray
        )
        
        SettingsRow(
            title: "Enabled",
            icon: "bolt.fill",
            color: .green
        ) {
            Toggle("", isOn: .constant(true))
        }
        
        SettingsRow(
            title: "Appearance",
            icon: "paintpalette.fill",
            color: .blue
        ) {
            Picker("", selection: .constant(1)) {
                Text("Dark").tag(0)
                Text("Light").tag(1)
            }
        }
    }
}
