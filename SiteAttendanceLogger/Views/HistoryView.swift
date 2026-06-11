import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: AttendanceStore
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            Group {
                if store.records.isEmpty {
                    emptyState
                } else {
                    recordsList
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showClearConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .disabled(store.records.isEmpty)
                }
            }
            .alert("Clear History", isPresented: $showClearConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    store.clearHistory()
                }
            } message: {
                Text("This will permanently delete all attendance records.")
            }
        }
    }

    private var emptyState: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                "No Records",
                systemImage: "tray",
                description: Text("Your attendance history will appear here.")
            )
        } else {
            VStack(spacing: 8) {
                Image(systemName: "tray")
                    .font(.system(size: 36))
                    .foregroundColor(.secondary)
                Text("No Records")
                    .font(.headline)
                Text("Your attendance history will appear here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        }
    }

    private var recordsList: some View {
        List {
            ForEach(store.records) { record in
                HStack(spacing: 12) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(record.siteName)
                            .font(.body)
                            .fontWeight(.medium)
                        HStack(spacing: 0) {
                            Text(record.timestamp, style: .date)
                            Text(" · ")
                            Text(record.timestamp, style: .time)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.insetGrouped)
    }
}
