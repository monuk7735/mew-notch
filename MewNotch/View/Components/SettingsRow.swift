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
    var size: CGFloat = 30
    var cornerRadius: CGFloat = 7
    var font: Font = .headline

    init(
        icon: Image,
        color: Color,
        size: CGFloat = 30,
        cornerRadius: CGFloat = 7,
        font: Font = .headline
    ) {
        self.icon = icon
        self.color = color
        self.size = size
        self.cornerRadius = cornerRadius
        self.font = font
    }

    init(
        icon: AppIcon,
        color: Color,
        size: CGFloat = 30,
        cornerRadius: CGFloat = 7,
        font: Font = .headline
    ) {
        self.init(
            icon: icon.image,
            color: color,
            size: size,
            cornerRadius: cornerRadius,
            font: font
        )
    }

    var body: some View {
        icon
            .font(font)
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color.gradient)
                    .shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 0.5)
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
        HStack(spacing: 9) {
            SettingsIcon(
                icon: icon,
                color: color,
                size: 20,
                cornerRadius: 5,
                font: .system(size: 11, weight: .semibold)
            )
            Text(title)
                .font(.system(size: 13, weight: .regular))
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

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let subtitle {
                    Text(subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            content
                .labelsHidden()
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
