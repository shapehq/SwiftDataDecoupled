import CoreData
import DB
import SwiftData

@Observable
public final class SwiftDataEntryRepository: EntryRepository {
    public var models: [SwiftDataEntry] {
        fetchedResultsController.models
    }

    private let modelContext: ModelContext
    private let fetchedResultsController: FetchedResultsController<SwiftDataEntry>

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchedResultsController = FetchedResultsController(
            modelContext: modelContext, 
            sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
        )
    }

    public func addEntry() {
        let entry = SwiftDataEntry()
        modelContext.insert(entry)
    }

    public func deleteEntry(_ entry: SwiftDataEntry) {
        modelContext.delete(entry)
    }

    public func fetchModels() throws {
        try fetchedResultsController.fetch()
    }
}
