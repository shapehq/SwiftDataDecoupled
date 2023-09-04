import SwiftData

public struct SwiftDataDB {
    public let modelContainer: ModelContainer

    public init(isStoredInMemoryOnly: Bool) {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        modelContainer = try! ModelContainer(
            for: SwiftDataEntry.self, 
            configurations: modelConfiguration
        )
    }
}
