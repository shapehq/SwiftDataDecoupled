import DB
import Foundation
import SwiftData

@Model
public final class SwiftDataEntry: Entry {
    public let date: Date
    public var isEnabled = false

    public init() {
        self.date = Date()
    }
}
