import DB
import SwiftUI

struct EntryListView<EntryRepositoryType: EntryRepository>: View {
    let entryRepository: EntryRepositoryType

    @State private var selectedEntry: EntryRepositoryType.EntryType?

    var body: some View {
        NavigationView {
            List {
                ForEach(entryRepository.models) { entry in
                    EntryRow(entry: entry) {
                        selectedEntry = entry
                    } onDelete: {
                        entryRepository.deleteEntry(entry)
                    }
                }
            }
            .animation(.default, value: entryRepository.models)
            .navigationTitle("Entries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    AddButton {
                        entryRepository.addEntry()
                    }
                }
            }
            .sheetPresentation(presentedItem: $selectedEntry) { entry in
                EntryDetailView(entry: entry)
            }
            .onAppear {
                do {
                    try entryRepository.fetchModels()
                } catch {}
            }
        }
    }
}

#Preview {
    EntryListView(
        entryRepository: PreviewEntryRepository(models: [
            PreviewEntry(
                date: Date().addingTimeInterval(-3600),
                isEnabled: false
            ),
            PreviewEntry(
                date: Date().addingTimeInterval(-9000),
                isEnabled: true
            ),
            PreviewEntry(
                date: Date().addingTimeInterval(-12 * 3600),
                isEnabled: true
            )
        ])
    )
}
