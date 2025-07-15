//
//  ShelfFileGroupView.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import SwiftUI

struct ShelfFileGroupView: View {
    
    var shelfGroupModel: ShelfFileGroupModel
    var onDelete: () -> Void
    
    @State private var isHovered: Bool = false
    
    var body: some View {
        RoundedRectangle(
            cornerRadius: 12
        )
        .stroke(
            .white.opacity(
                0.5
            ),
            lineWidth: 1
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
                    nsImage: shelfGroupModel.preview
                )
                .resizable()
                .scaledToFit()
                
                MarqueeTextView(
                    text: shelfGroupModel.groupName,
                    font: .labelFont(
                        ofSize: 12
                    ),
                    leftFade: 4,
                    rightFade: 4,
                    startDelay: 1
                )
            }
            .font(
                .body
            )
            .padding(4)
        }
        .onMultiDrag {
            shelfGroupModel.files.map {
                $0.fileURL as NSURL
            }
        }
        .overlay {
            if isHovered {
                Image(
                    systemName: "xmark.circle.fill"
                )
                .onTapGesture {
                    self.onDelete()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
            }
        }
        .onHover { isHovered in
            withAnimation {
                self.isHovered = isHovered
            }
        }
    }
}
