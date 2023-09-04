import DB
import Foundation

final class PreviewEntry: Entry {
    let date: Date
    var isEnabled: Bool

    init(date: Date, isEnabled: Bool) {
        self.date = date
        self.isEnabled = isEnabled
    }

    static func == (lhs: PreviewEntry, rhs: PreviewEntry) -> Bool {
        lhs.date == rhs.date && lhs.isEnabled == rhs.isEnabled
    }
}
