import SwiftUI

struct AddButton: View {
    let onSelect: () -> Void

    var body: some View {
        Button {
            onSelect()
        } label: {
            Image(systemName: "plus")
        }
    }
}

#Preview {
    AddButton(onSelect: {})
}
