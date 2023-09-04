import DBSwiftData
import SwiftUI

@main
struct ExampleApp: App {
    private let db: SwiftDataDB

    init() {
        db = SwiftDataDB(isStoredInMemoryOnly: false)
    }

    var body: some Scene {
        WindowGroup {
            EntryListView(
                entryRepository: SwiftDataEntryRepository(
                    modelContext: db.modelContainer.mainContext
                )
            )
        }
    }
}
