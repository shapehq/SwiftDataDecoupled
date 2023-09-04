import DB
import SwiftUI

struct EntryDetailHeader<EntryType: Entry>: View {
    let entry: EntryType

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    var body: some View {
        ZStack {
            HStack {
                DismissButton()
                    .tint(.secondary)
                Spacer()
            }
            Text(dateFormatter.string(from: entry.date))
                .font(.headline)
                .padding([.leading, .trailing])
        }
        .padding(.top)
    }
}

#Preview {
    EntryDetailHeader(
        entry: PreviewEntry(date: Date(), isEnabled: false)
    )
}
