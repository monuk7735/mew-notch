//
//  FileShelfView.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileShelfView: View {
    @StateObject var notchDefaults = NotchDefaults.shared

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel

    @State private var errorMessage: String?
    @State private var showError: Bool = false

    @State private var isShelfDropTarget: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            AirDropView(
                notchViewModel: notchViewModel,
                onError: { error in
                    errorMessage = error.localizedDescription
                    showError = true
                }
            )
            .frame(
                width: notchViewModel.expandedNotchSize.height * 3,
                height: notchViewModel.expandedNotchSize.height * 3
            )

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColor.Surface.darkSubtle.opacity(0.5))

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isShelfDropTarget ? Color.blue
                            : (expandedNotchViewModel.shelfFileGroups.isEmpty ? Color.white.opacity(0.3) : Color.white.opacity(0.12)),
                        style: StrokeStyle(
                            lineWidth: isShelfDropTarget ? 2 : 1,
                            dash: (expandedNotchViewModel.shelfFileGroups.isEmpty || isShelfDropTarget) ? [5, 5] : []
                        )
                    )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(expandedNotchViewModel.shelfFileGroups) { fileGroupModel in
                            ShelfFileGroupView(
                                notchViewModel: notchViewModel,
                                shelfGroupModel: fileGroupModel,
                                onRename: { newName in
                                    expandedNotchViewModel.renameShelfGroup(id: fileGroupModel.id, to: newName)
                                },
                                onDelete: {
                                    expandedNotchViewModel.removeShelfGroup(id: fileGroupModel.id)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .frame(maxHeight: .infinity)
                }

                if expandedNotchViewModel.shelfFileGroups.isEmpty {
                    VStack(spacing: 6) {
                        AppIcon.trayArrowDown.image
                            .font(.system(size: 22))
                            .foregroundStyle(isShelfDropTarget ? Color.blue : Color.white.opacity(0.7))

                        VStack(spacing: 2) {
                            Text(isShelfDropTarget ? "Drop to Add to Shelf" : "Drop Files or Paste")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(isShelfDropTarget ? Color.blue : Color.white.opacity(0.7))

                            if !isShelfDropTarget {
                                Text("(only supported with right click for now)")
                                    .font(.system(size: 10, weight: .regular, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.4))
                            }
                        }
                    }
                }

                if showError, let errorMessage {
                    VStack(spacing: 8) {
                        AppIcon.warning.image
                            .font(.title2)
                            .foregroundStyle(.yellow)
                        Text(errorMessage)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showError = false
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .dropDestination(
                for: URL.self,
                action: { fileURLs, _ in
                    guard !ShelfStorageManager.isDraggingFromShelf else { return false }
                    let externalURLs = fileURLs.filter { !ShelfStorageManager.shared.isShelfURL($0) }
                    guard !externalURLs.isEmpty else { return false }
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let groupModel = ShelfFileGroupModel(
                            urls: externalURLs
                        ) else {
                            return
                        }

                        DispatchQueue.main.async {
                            expandedNotchViewModel.addShelfGroup(
                                groupModel
                            )
                        }
                    }

                    return true
                },
                isTargeted: { targeted in
                    if targeted, ShelfStorageManager.isDraggingFromShelf {
                        isShelfDropTarget = false
                        return
                    }
                    isShelfDropTarget = targeted
                }
            )
            .contextMenu {
                Button {
                    expandedNotchViewModel.pasteFromClipboard()
                } label: {
                    Label("Paste from Clipboard", systemImage: "doc.on.clipboard")
                }

                if !expandedNotchViewModel.shelfFileGroups.isEmpty {
                    Divider()

                    Button(role: .destructive) {
                        for group in expandedNotchViewModel.shelfFileGroups {
                            group.cleanup()
                        }
                        withAnimation {
                            expandedNotchViewModel.shelfFileGroups.removeAll()
                        }
                    } label: {
                        Label("Clear Shelf", systemImage: "trash")
                    }
                }
            }
            .background {
                Button("") {
                    expandedNotchViewModel.pasteFromClipboard()
                }
                .keyboardShortcut("v", modifiers: .command)
                .opacity(0)
                .frame(width: 0, height: 0)
            }
        }
        .frame(
            width: notchViewModel.expandedNotchSize.width * 2.2,
            height: notchViewModel.expandedNotchSize.height * 3,
            alignment: .bottom
        )
    }
}

struct AirDropView: View {
    @ObservedObject var notchViewModel: NotchViewModel
    var onError: (Error) -> Void

    @State private var isHovered = false
    @State private var isTargeted = false

    var body: some View {
        Button {
            let picker = NSOpenPanel()
            picker.allowsMultipleSelection = true
            picker.canChooseDirectories = true
            picker.canChooseFiles = true

            if picker.runModal() == .OK {
                let drop = AirDrop(files: picker.urls)
                drop.begin { error in
                    if let error {
                        onError(error)
                    }
                }
            }
        } label: {
            VStack(spacing: 6) {
                AppIcon.shareplay.image
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
                    .foregroundStyle(.white)
                    .scaleEffect(isHovered || isTargeted ? 1.1 : 1.0)

                Text("AirDrop")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)

                    .fill(AppColor.Surface.dark)
                    .overlay {
                        if isHovered || isTargeted {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.blue, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
        .onHover { hovered in
            withAnimation {
                isHovered = hovered
            }
        }
        .dropDestination(
            for: URL.self,
            action: { files, _ in
                let drop = AirDrop(files: files)
                drop.begin { error in
                    if let error {
                        onError(error)
                    }
                }
                return true
            },
            isTargeted: { targeted in
                isTargeted = targeted
                notchViewModel.isDropTarget = targeted
            }
        )
    }
}
