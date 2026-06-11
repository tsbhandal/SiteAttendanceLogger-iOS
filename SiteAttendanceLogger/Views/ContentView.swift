import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AttendanceStore
    @State private var selectedSite: String = "Woodthorn"
    @State private var showAddSite = false
    @State private var showHistory = false
    @State private var showExportConfirm = false
    @State private var newSiteName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Site Selection Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("SELECT SITE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(1)

                    Picker("Choose a site", selection: $selectedSite) {
                        ForEach(store.sites, id: \.self) { site in
                            Text(site).tag(site)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Log Button
                    Button(action: logAttendance) {
                        Label("Log Visit", systemImage: "location.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .cornerRadius(12)
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Action buttons
                HStack(spacing: 12) {
                    Button(action: { showAddSite = true }) {
                        Label("Add Site", systemImage: "plus.circle")
                            .font(.subheadline)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.blue)

                    Spacer()

                    Button(action: { showExportConfirm = true }) {
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                            .font(.subheadline)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 32)
                .padding(.top, 12)

                // Recent visits header
                HStack {
                    Text("RECENT VISITS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(1)
                    Spacer()
                    Button(action: { showHistory = true }) {
                        Text("See All")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)

                // Recent visits list
                if store.records.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "No Visits Yet",
                        systemImage: "clock",
                        description: Text("Tap \"Log Visit\" to record your first attendance.")
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(Array(store.records.prefix(10))) { record in
                            VisitRow(record: record)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Site Logger")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddSite) {
                AddSiteView(store: store)
            }
            .sheet(isPresented: $showHistory) {
                HistoryView()
            }
            .alert("Export Complete", isPresented: $showExportConfirm) {
                Button("OK") {}
            } message: {
                Text("Attendance data has been exported.")
            }
        }
    }

    private func logAttendance() {
        store.logAttendance(site: selectedSite)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

struct VisitRow: View {
    let record: AttendanceRecord

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(.orange)
                .frame(width: 4, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.siteName)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(record.timestamp, style: .date) +
                Text(" at ") +
                Text(record.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
