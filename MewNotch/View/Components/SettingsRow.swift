//
//  SettingsRow.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/2026.
//

import SwiftUI

struct SettingsIcon: View {
    let icon: Image
    let color: Color

    @ScaledMetric private var iconSize: CGFloat = 30
    @ScaledMetric private var cornerRadius: CGFloat = 7

    init(icon: Image, color: Color) {
        self.icon = icon
        self.color = color
    }

    init(icon: AppIcon, color: Color) {
        self.icon = icon.image
        self.color = color
    }

    var body: some View {
        icon
            .font(.headline)
            .foregroundStyle(.white)
            .frame(width: iconSize, height: iconSize)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color.gradient)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            )
    }
}

struct SettingsSidebarRow: View {
    let title: LocalizedStringKey
    let icon: Image
    let color: Color

    init(title: LocalizedStringKey, icon: Image, color: Color) {
        self.title = title
        self.icon = icon
        self.color = color
    }

    init(title: LocalizedStringKey, icon: AppIcon, color: Color) {
        self.title = title
        self.icon = icon.image
        self.color = color
    }

    var body: some View {
        HStack(spacing: 12) {
            SettingsIcon(icon: icon, color: color)
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 2)
    }
}

struct SettingsRow<Content: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let icon: Image
    let color: Color
    let content: Content

    @ScaledMetric private var spacing: CGFloat = 16

    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        icon: Image,
        color: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.content = content()
    }

    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        icon: AppIcon,
        color: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon.image,
            color: color,
            content: content
        )
    }

    var body: some View {
        HStack(spacing: spacing) {
            SettingsIcon(icon: icon, color: color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                if let subtitle {
                    Text(subtitle)
                        .font(.body)
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

/// Convenience init for no content (just label)
extension SettingsRow where Content == EmptyView {
    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        icon: Image,
        color: Color
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon,
            color: color,
            content: { EmptyView() }
        )
    }

    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        icon: AppIcon,
        color: Color
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            icon: icon.image,
            color: color
        )
    }
}

#Preview {
    List {
        SettingsRow(
            title: "General Settings",
            subtitle: "Takes you to general settings",
            icon: .general,
            color: .gray
        )

        SettingsRow(
            title: "Enabled",
            icon: .power,
            color: .green
        ) {
            Toggle("", isOn: .constant(true))
        }

        SettingsRow(
            title: "Appearance",
            icon: .paintbrush,
            color: .blue
        ) {
            Picker("", selection: .constant(1)) {
                Text("Dark").tag(0)
                Text("Light").tag(1)
            }
        }
    }
}
