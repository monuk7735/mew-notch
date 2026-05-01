import SwiftUI

struct CalendarQuickView: View {
    
    private var formattedDate: String {
        Date.now.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var formattedTime: String {
        Date.now.formatted(date: .omitted, time: .shortened)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Calendar", systemImage: "calendar")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(formattedDate)
                .font(.headline)
            
            Text(formattedTime)
                .font(.title3.bold())
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}
