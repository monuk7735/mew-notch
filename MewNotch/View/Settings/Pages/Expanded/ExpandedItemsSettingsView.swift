import SwiftUI
import UniformTypeIdentifiers

struct ExpandedItemsSettingsView: View {
    
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    @State private var selectedItem: ExpandedNotchItem? = .Mirror
    
    var body: some View {
        VStack(spacing: 0) {
            // Unified Header Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Manage and Order Items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("Show Separator")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Toggle("", isOn: $notchDefaults.showDividers)
                            .toggleStyle(.switch)
                            .labelsHidden()
                            .controlSize(.small)
                            .scaleEffect(0.8)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(notchDefaults.expandedItemsOrder.enumerated()), id: \.element) { index, item in
                            let isEnabled = notchDefaults.expandedNotchItems.contains(item)
                            
                            ExpandedItemTabButton(
                                item: item,
                                selection: $selectedItem,
                                isEnabled: isEnabled,
                                showLeftArrow: index > 0,
                                showRightArrow: index < notchDefaults.expandedItemsOrder.count - 1,
                                onToggle: {
                                    toggleItem(item)
                                },
                                onMoveLeft: {
                                    moveItem(at: index, direction: -1)
                                },
                                onMoveRight: {
                                    moveItem(at: index, direction: 1)
                                }
                            )
                            .opacity(isEnabled ? 1.0 : 0.8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                Divider()
            }
            .padding(.top)
            .background(Color(NSColor.windowBackgroundColor))
            
            // Content View
            Group {
                if let item = selectedItem {
                    switch item {
                    case .Mirror:
                        ExpandedMirrorSettingsView()
                    case .NowPlaying:
                        ExpandedNowPlayingSettingsView()
                    case .Bash:
                        ExpandedBashSettingsView()
                    }
                } else {
                    ContentUnavailableView(
                        "Select an Item",
                        systemImage: "arrow.up",
                        description: Text("Select an item above to configure its settings.")
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Expanded Items")
        .toolbarTitleDisplayMode(.inline)

    }
    
    private func toggleItem(_ item: ExpandedNotchItem) {
        if let index = notchDefaults.expandedNotchItems.firstIndex(of: item) {
            notchDefaults.expandedNotchItems.remove(at: index)
        } else {
            notchDefaults.expandedNotchItems.append(item)
            resortActiveItems()
        }
    }
    
    private func moveItem(at index: Int, direction: Int) {
        let newIndex = index + direction
        guard newIndex >= 0 && newIndex < notchDefaults.expandedItemsOrder.count else { return }
        
        withAnimation {
            notchDefaults.expandedItemsOrder.swapAt(index, newIndex)
            resortActiveItems()
        }
    }
    
    private func resortActiveItems() {
        notchDefaults.expandedNotchItems.sort { a, b in
            let indexA = notchDefaults.expandedItemsOrder.firstIndex(of: a) ?? 0
            let indexB = notchDefaults.expandedItemsOrder.firstIndex(of: b) ?? 0
            return indexA < indexB
        }
    }
}

struct ExpandedItemTabButton: View {
    let item: ExpandedNotchItem
    @Binding var selection: ExpandedNotchItem?
    let isEnabled: Bool
    let showLeftArrow: Bool
    let showRightArrow: Bool
    let onToggle: () -> Void
    let onMoveLeft: () -> Void
    let onMoveRight: () -> Void
    
    var isSelected: Bool { selection == item }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.2)) {
                    selection = item
                }
            } label: {
                VStack(spacing: 16) {
                    // Top: Icon
                    VStack(spacing: 12) {
                        Image(systemName: item.imageSystemName)
                            .font(.system(size: 24))
                        
                        Text(item.displayName)
                            .font(.caption.weight(.medium))
                    }
                    .padding(.top, 12)
                    .foregroundStyle(isSelected ? .white : .secondary)
                    
                    // Bottom: Arrows + Toggle
                    HStack(spacing: 8) {
                        // Left Arrow
                        Button(action: onMoveLeft) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(isSelected ? .white : .secondary)
                                .frame(width: 24, height: 24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .opacity(showLeftArrow ? 1.0 : 0.3)
                        }
                        .buttonStyle(.plain)
                        .disabled(!showLeftArrow)
                        
                        // Toggle
                        Toggle("", isOn: Binding(
                            get: { isEnabled },
                            set: { _ in onToggle() }
                        ))
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .scaleEffect(0.6)
                        
                        // Right Arrow
                        Button(action: onMoveRight) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(isSelected ? .white : .secondary)
                                .frame(width: 24, height: 24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .opacity(showRightArrow ? 1.0 : 0.3)
                        }
                        .buttonStyle(.plain)
                        .disabled(!showRightArrow)
                    }
                    .padding(8)
                }
                .padding(8)
                .padding(.horizontal, 4)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ExpandedItemsSettingsView()
}
