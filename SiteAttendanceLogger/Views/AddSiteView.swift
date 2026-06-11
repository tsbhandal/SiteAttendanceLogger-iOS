import SwiftUI

struct AddSiteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: AttendanceStore
    @State private var siteName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Site Name")) {
                    TextField("e.g. North Warehouse", text: $siteName)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Add Site")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.addSite(siteName)
                        dismiss()
                    }
                    .disabled(siteName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
