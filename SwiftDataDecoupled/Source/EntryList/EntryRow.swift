import DB
import SwiftUI

struct EntryRow<EntryType: Entry>: View {
    let entry: EntryType
    let onSelect: () -> Void
    let onDelete: () -> Void

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    var body: some View {
        Button {
            onSelect()
        } label: {
            HStack {
                Text(dateFormatter.string(from: entry.date))
                if entry.isEnabled {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .tint(.primary)
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

#Preview {
    EntryRow(
        entry: PreviewEntry(date: Date(), isEnabled: false),
        onSelect: {},
        onDelete: {}
    )
}
