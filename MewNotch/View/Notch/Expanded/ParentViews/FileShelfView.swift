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
    
    var body: some View {
        HStack(spacing: 12) {
            AirDropView(
                notchViewModel: notchViewModel,
                onError: { error in
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            )
            .frame(
                width: notchViewModel.notchSize.height * 3,
                height: notchViewModel.notchSize.height * 3
            )
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(white: 0.1).opacity(0.5))
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        .white.opacity(0.3),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                    )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(expandedNotchViewModel.shelfFileGroups) { fileGroupModel in
                            ShelfFileGroupView(
                                shelfGroupModel: fileGroupModel
                            ) {
                                withAnimation {
                                    expandedNotchViewModel.shelfFileGroups.removeAll {
                                        $0.id == fileGroupModel.id
                                    }
                                }
                            }
                        }
                        

                        Color.clear
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(12)
                }
                

                
                if expandedNotchViewModel.shelfFileGroups.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "tray.and.arrow.down.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Text("Drop Files Here")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                

                
                if showError, let errorMessage = errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
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
                                self.showError = false
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(
             width: notchViewModel.notchSize.width * 2.2,
             height: notchViewModel.notchSize.height * 3,
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
                    if let error = error {
                        onError(error)
                    }
                }
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: "shareplay")
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

                    .fill(Color(white: 0.15))
                    .overlay {
                        if isHovered || isTargeted {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.blue, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .dropDestination(
            for: URL.self,
            action: { files, _ in
                let drop = AirDrop(files: files)
                drop.begin { error in
                    if let error = error {
                        onError(error)
                    }
                }
                return true
            },
            isTargeted: { targeted in
                self.isTargeted = targeted
                notchViewModel.isDropTarget = targeted
            }
        )
    }
}
