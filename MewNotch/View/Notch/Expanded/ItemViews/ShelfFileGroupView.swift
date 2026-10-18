//
//  ShelfFileGroupView.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import QuickLook
import SwiftUI

struct ShelfFileGroupView: View {
    @ObservedObject var notchViewModel: NotchViewModel
    var shelfGroupModel: ShelfFileGroupModel
    var onRename: (String) -> Void
    var onDelete: () -> Void

    @State private var isHovered: Bool = false
    @State private var isRenaming: Bool = false
    @State private var editedName: String = ""
    @FocusState private var isFieldFocused: Bool
    @State private var quickLookURL: URL?
    @State private var localClickMonitor: Any?
    @State private var globalClickMonitor: Any?

    private var currentWindow: NSWindow? {
        NotchManager.shared.windows[notchViewModel.screen]
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 4) {
                previewThumbnail
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        quickLookURL = shelfGroupModel.folderURL ?? shelfGroupModel.files.first?.fileURL
                    }

                titleView
            }
            .padding(6)
            .frame(maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background {
                if isHovered || isRenaming {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                }
            }
            .contextMenu {
                Button {
                    startRenaming()
                } label: {
                    Label("Rename", systemImage: "pencil")
                }

                Button {
                    quickLookURL = shelfGroupModel.folderURL ?? shelfGroupModel.files.first?.fileURL
                } label: {
                    Label("Quick Look", systemImage: "eye")
                }

                Button {
                    shelfGroupModel.revealInFinder()
                } label: {
                    Label("Reveal in Finder", systemImage: "folder")
                }

                Button {
                    shelfGroupModel.copyToClipboard()
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }

                Divider()

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Remove from Shelf", systemImage: "trash")
                }
            }

            if isHovered, !isRenaming {
                Button {
                    onDelete()
                } label: {
                    AppIcon.close.image
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Circle().fill(AppColor.Interactive.destructive))
                }
                .buttonStyle(.plain)
                .offset(x: 2, y: -2)
                .transition(.opacity.animation(.easeInOut(duration: 0.1)))
            }
        }
        .padding(.horizontal, 2)
        .quickLookPreview($quickLookURL)
        .onHover { hovered in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovered
            }
        }
        .onChange(of: isFieldFocused) { _, isFocused in
            if !isFocused, isRenaming {
                commitRename()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didResignKeyNotification)) { notification in
            guard isRenaming else { return }
            if let resigningWindow = notification.object as? NSWindow,
               let window = currentWindow,
               resigningWindow === window {
                commitRename()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
            if isRenaming {
                commitRename()
            }
        }
        .onDisappear {
            removeClickMonitors()
            if isRenaming {
                cancelRename()
            }
        }
    }

    private var previewThumbnail: some View {
        GeometryReader { proxy in
            let iconSize = min(proxy.size.width, proxy.size.height)

            ZStack {
                if shelfGroupModel.files.count > 1, !shelfGroupModel.isPackagedFolder {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: max(iconSize - 6, 0), height: max(iconSize - 6, 0))
                        .offset(x: 3, y: -3)
                }

                if shelfGroupModel.isImage {
                    Image(nsImage: shelfGroupModel.preview)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: iconSize, height: iconSize)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        }
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                } else {
                    Image(nsImage: shelfGroupModel.preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                if shelfGroupModel.files.count > 1, !shelfGroupModel.isPackagedFolder {
                    Text("\(shelfGroupModel.files.count)")
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(Color.blue))
                        .offset(x: 2, y: -2)
                }
            }
        }
        .if(!isRenaming) { view in
            view.onMultiDrag {
                if shelfGroupModel.isPackagedFolder, let folderURL = shelfGroupModel.folderURL {
                    [folderURL as NSURL]
                } else {
                    shelfGroupModel.files.map { $0.fileURL as NSURL }
                }
            }
        }
    }

    @ViewBuilder
    private var titleView: some View {
        if isRenaming {
            TextField("", text: $editedName)
                .textFieldStyle(.plain)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 3)
                .padding(.vertical, 1)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.black.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                )
                .focused($isFieldFocused)
                .onSubmit {
                    commitRename()
                }
                .onExitCommand {
                    cancelRename()
                }
        } else {
            Text(shelfGroupModel.groupName)
                .font(.system(size: 10, weight: .medium))
                .lineLimit(1)
                .truncationMode(.middle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    startRenaming()
                }
        }
    }

    private func startRenaming() {
        if shelfGroupModel.files.count == 1, let first = shelfGroupModel.files.first {
            editedName = (first.displayName as NSString).deletingPathExtension
        } else {
            editedName = shelfGroupModel.groupName
        }
        notchViewModel.isRenaming = true
        withAnimation(.easeInOut(duration: 0.15)) {
            isRenaming = true
        }

        NSRunningApplication.current.activate(options: [.activateAllWindows])
        currentWindow?.makeKey()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            currentWindow?.makeKey()
            isFieldFocused = true
            setupClickMonitors()
            DispatchQueue.main.async {
                if let textView = currentWindow?.firstResponder as? NSTextView {
                    textView.selectAll(nil)
                }
            }
        }
    }

    private func commitRename() {
        removeClickMonitors()
        let trimmed = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            onRename(trimmed)
        }
        notchViewModel.isRenaming = false
        withAnimation(.easeInOut(duration: 0.15)) {
            isRenaming = false
        }
        currentWindow?.resignKey()
        NSApp.deactivate()
        if !notchViewModel.isHovered, !notchViewModel.isPinned {
            notchViewModel.collapse()
        }
    }

    private func cancelRename() {
        removeClickMonitors()
        notchViewModel.isRenaming = false
        withAnimation(.easeInOut(duration: 0.15)) {
            isRenaming = false
        }
        currentWindow?.resignKey()
        NSApp.deactivate()
        if !notchViewModel.isHovered, !notchViewModel.isPinned {
            notchViewModel.collapse()
        }
    }

    private func setupClickMonitors() {
        removeClickMonitors()

        globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { _ in
            DispatchQueue.main.async {
                if isRenaming {
                    commitRename()
                }
            }
        }

        localClickMonitor = NSEvent.addLocalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { event in
            if isRenaming,
               let eventWindow = event.window,
               let window = currentWindow,
               eventWindow === window,
               let firstResponder = window.firstResponder as? NSView,
               firstResponder is NSTextView {
                let clickPoint = event.locationInWindow
                let pointInResponder = firstResponder.convert(clickPoint, from: nil)
                if !firstResponder.bounds.insetBy(dx: -4, dy: -4).contains(pointInResponder) {
                    DispatchQueue.main.async {
                        commitRename()
                    }
                }
            }
            return event
        }
    }

    private func removeClickMonitors() {
        if let monitor = localClickMonitor {
            NSEvent.removeMonitor(monitor)
            localClickMonitor = nil
        }
        if let monitor = globalClickMonitor {
            NSEvent.removeMonitor(monitor)
            globalClickMonitor = nil
        }
    }
}
