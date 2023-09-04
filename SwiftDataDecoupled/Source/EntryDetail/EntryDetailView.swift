import DB
import SwiftUI

struct EntryDetailView<EntryType: Entry>: View {
    @Bindable var entry: EntryType

    var body: some View {
        CardContainer {
            VStack(spacing: 0) {
                EntryDetailHeader(entry: entry)
                Spacer()
                HStack {
                    Spacer()
                    Toggle(isOn: $entry.isEnabled) {
                        Text("Enabled")
                    }
                    .fixedSize(horizontal: true, vertical: true)
                    Spacer()
                }
                .padding([.leading, .trailing])
                Spacer()
            }
        }
    }
}

#Preview {
    EntryDetailView(
        entry: PreviewEntry(date: Date(), isEnabled: false)
    )
}
