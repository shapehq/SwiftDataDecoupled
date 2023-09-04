import Foundation

public protocol EntryRepository: AnyObject, Observable {
    associatedtype EntryType: Entry
    var models: [EntryType] { get }
    func addEntry()
    func deleteEntry(_ entry: EntryType)
    func fetchModels() throws
}
