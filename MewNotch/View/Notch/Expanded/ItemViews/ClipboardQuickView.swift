import SwiftUI

struct ClipboardQuickView: View {
    
    @State private var clipboardText: String = NSPasteboard.general.string(forType: .string) ?? ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Clipboard", systemImage: "clipboard")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(clipboardText.isEmpty ? "Clipboard vacío" : clipboardText)
                .font(.body)
                .lineLimit(3)
                .textSelection(.enabled)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            clipboardText = NSPasteboard.general.string(forType: .string) ?? ""
        }
    }
}
