import SwiftUI

@main
struct SiteAttendanceLoggerApp: App {
    @StateObject private var store = AttendanceStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
