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
    
    var body: some View {
        HStack {
            AirDropView(
                notchViewModel: notchViewModel
            )
            
            ScrollView(
                .horizontal
            ) {
                HStack(
                    spacing: 8
                ) {
                    ForEach(
                        expandedNotchViewModel.shelfFileGroups
                    ) { fileGroupModel in
                        ShelfFileGroupView(
                            shelfGroupModel: fileGroupModel
                        ) {
                            withAnimation {
                                expandedNotchViewModel.shelfFileGroups
                                    .removeAll {
                                        $0.id == fileGroupModel.id
                                    }
                            }
                        }
                    }
                    
                    Text(" ")
                        .frame(
                            maxHeight: .infinity
                        )
                }
                .padding(8)
                
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: 12
                )
                .stroke(
                    .white.opacity(0.7),
                    style: .init(
                        lineWidth: 2,
                        dash: [5, 5]
                    )
                )
            }
            .overlay {
                VStack(
                    spacing: 12
                ) {
                    Image(
                        systemName: notchDefaults.shownOnLockScreen ? "exclamationmark.triangle.fill" : "tray.and.arrow.down.fill"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: 16
                    )
                    
                    if notchDefaults.shownOnLockScreen {
                        Text("Incompatible with ") + Text("Show on Lockscreen").bold()
                    } else {
                        Text("Drop Files Here")
                    }
                }
                .font(
                    .body.weight(
                        .medium
                    )
                )
                .opacity(
                    expandedNotchViewModel.shelfFileGroups.isEmpty
                    ? 0.6
                    : 0
                )
            }
        }
        .frame(
            width: notchViewModel.notchSize.width * 2,
            height: notchViewModel.notchSize.height * 3,
            alignment: .bottom
        )
    }
}

struct AirDropView: View {
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    var body: some View {
        RoundedRectangle(
            cornerRadius: 12
        )
        .fill(
            .white.opacity(
                0.3
            )
        )
        .aspectRatio(
            1,
            contentMode: .fit
        )
        .overlay {
            VStack(
                spacing: 8
            ) {
                Image(
                    systemName: "airplayaudio"
                )
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: 32
                )
                
                Text("AirDrop")
            }
            .font(
                .body
            )
        }
        .onTapGesture {
//            DispatchQueue.main.asyncAfter(
//                deadline: .now() + 0.5
//            ) {
                let picker = NSOpenPanel()
                picker.allowsMultipleSelection = true
                picker.canChooseDirectories = true
                picker.canChooseFiles = true
                
                if picker.runModal() == .OK {
                    let drop = AirDrop(
                        files: picker.urls
                    )
                    drop.begin()
                }
//            }
        }
        .dropDestination(
            for: URL.self,
            action: { files, _ in
                let drop = AirDrop(
                    files: files
                )
                drop.begin()
                
                return true
            },
            isTargeted: {
                notchViewModel.isDropTarget = $0
            }
        )
    }
}
