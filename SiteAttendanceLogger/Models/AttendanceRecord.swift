import Foundation

struct AttendanceRecord: Identifiable, Codable {
    let id: UUID
    let siteName: String
    let timestamp: Date

    init(siteName: String) {
        self.id = UUID()
        self.siteName = siteName
        self.timestamp = Date()
    }
}
