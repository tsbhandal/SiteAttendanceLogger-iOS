import Foundation

class AttendanceStore: ObservableObject {
    @Published var sites: [String] {
        didSet { saveSites() }
    }
    @Published var records: [AttendanceRecord] {
        didSet { saveRecords() }
    }

    private let sitesKey = "saved_sites"
    private let recordsKey = "attendance_records"
    private let defaults = UserDefaults.standard

    init() {
        // Load saved data or use defaults
        if let data = defaults.data(forKey: sitesKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            sites = decoded
        } else {
            sites = ["Woodthorn", "Mira Digital Shower", "Site C"]
        }

        if let data = defaults.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([AttendanceRecord].self, from: data) {
            records = decoded
        } else {
            records = []
        }
    }

    func logAttendance(site: String) {
        let record = AttendanceRecord(siteName: site)
        records.insert(record, at: 0) // newest first
    }

    func addSite(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !sites.contains(trimmed) else { return }
        sites.append(trimmed)
    }

    func clearHistory() {
        records.removeAll()
    }

    func exportCSV() -> URL? {
        var csv = "Site,Date,Time\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd,HH:mm"
        for record in records {
            let dateStr = formatter.string(from: record.timestamp)
            csv += "\(record.siteName),\(dateStr)\n"
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("attendance_export.csv")
        do {
            try csv.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            return nil
        }
    }

    private func saveSites() {
        if let data = try? JSONEncoder().encode(sites) {
            defaults.set(data, forKey: sitesKey)
        }
    }

    private func saveRecords() {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: recordsKey)
        }
    }
}
