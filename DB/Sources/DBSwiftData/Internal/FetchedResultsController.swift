import CoreData
import Foundation
import SwiftData

@Observable
final class FetchedResultsController<T: PersistentModel> {
    private(set) var models: [T] = []

    private let modelContext: ModelContext
    private let predicate: Predicate<T>?
    private let sortDescriptors: [SortDescriptor<T>]

    init(
        modelContext: ModelContext,
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) {
        self.modelContext = modelContext
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        setupNotification()
    }

    func fetch() throws {
        let fetchDesciptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        models = try modelContext.fetch(fetchDesciptor)
    }

    private func setupNotification() {
        // Ideally we'd use the ModelContext.didSave notification but this doesn't seem to be sent. 
        // Last tested with iOS 17 beta 8 on September 4th, 2023.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSave),
            name: .NSPersistentStoreRemoteChange,
            object: nil
        )
    }

    @objc private func didSave(_ notification: Notification) {
        do {
            try fetch()
        } catch {}
    }
}
