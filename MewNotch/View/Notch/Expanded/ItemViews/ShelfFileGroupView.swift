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
        ZStack(alignment: .topTrailing) {
            
            VStack(spacing: 8) {
                Image(nsImage: shelfGroupModel.preview)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 40)
                
                MarqueeTextView(
                    text: shelfGroupModel.groupName,
                    font: .systemFont(ofSize: 11, weight: .medium),
                    leftFade: 4,
                    rightFade: 4,
                    startDelay: 1
                )
                .foregroundStyle(.white)
            }
            .padding(8)
            .frame(width: 80, height: 80)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(white: 0.2))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    }
            }
            .onMultiDrag {
                shelfGroupModel.files.map { $0.fileURL as NSURL }
            }
            
            
            if isHovered {
                Button {
                    self.onDelete()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(Circle().fill(Color.red.opacity(0.9)))
                }
                .buttonStyle(.plain)
                .offset(x: 4, y: -4)
                .transition(.opacity.animation(.easeInOut(duration: 0.1)))
            }
        }
        .padding(6)
        .onHover { isHovered in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isHovered = isHovered
            }
        }
    }
}

