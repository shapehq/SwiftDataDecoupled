import DB

final class PreviewEntryRepository: EntryRepository {
    let models: [PreviewEntry]

    init(models: [PreviewEntry] = []) {
        self.models = models
    }

    func addEntry() {}

    func deleteEntry(_ entry: PreviewEntry) {}

    func fetchModels() throws {}
}
