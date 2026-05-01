import SwiftUI

struct FilesQuickView: View {
    
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel
    
    private var filesCount: Int {
        expandedNotchViewModel.shelfFileGroups.reduce(0) { $0 + $1.files.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Files", systemImage: "folder.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("\(filesCount) archivos guardados")
                .font(.headline)
            
            Button("Abrir Shelf") {
                expandedNotchViewModel.currentView = .Shelf
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}
