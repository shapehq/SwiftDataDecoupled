# SwiftDataDecoupled
Example project showing how the data and view layers can be decoupled when using SwiftData for persistence.

![](https://github.com/shapehq/SwiftDataDecoupled/blob/main/preview.gif?raw=true)

## ✨ Motivation

During WWDC23 Apple announced [SwiftData](https://developer.apple.com/documentation/swiftdata), a framework for quickly adding persistence to iOS apps. SwiftData builds on top of [Core Data](https://developer.apple.com/documentation/coredata/) but moves schema definition to plain Swift files. Consider the following model which defines a model that can be persisted using SwiftData.

```swift
@Model
final class EntryModel {
    let date: Date
    var isEnabled = false

    public init() {
        self.date = Date()
    }
}
```

Not only does this type specify the Swift model but it also specifies the schema of the underlying Core Data store. This is execellent and makes data persistence much simpler.

Apple's suggested way of using SwiftData in SwiftUI is using the [@Query](https://developer.apple.com/documentation/swiftdata/query) property wrapper and passing a [ModelContext](https://developer.apple.com/documentation/SwiftData/ModelContext) to the view using the [modelContext](https://developer.apple.com/documentation/SwiftUI/EnvironmentValues/modelContext) environment value.

```swift
struct EntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var models: [EntryModel]

    var body: some View {
        List {
            ForEach(models) { model in
                Text(entry.date, style: \.date)
            }
        }
    }
}
```

The downside of this is that it our views know about SwiftData, and as such, our views become tightly coupled to a specific database. We want to ensure our view layer is loosely coupled to our data layer.

## 🧪 Solution

To achieve loose coupling between our SwiftUI view and the underlying SwiftData store, we utilize Dependency Injection to inject our data store through constructors. We add [a local Swift package named DB](https://github.com/shapehq/SwiftDataDecoupled/tree/main/DB) which contains the following two targets.

|Target|Description
|-|-|
|DB|The interface for our database.|
|DBSwiftData|Concrete implementations of the interfaces in defined the DB target. These implementations use SwiftData for persisting data.|

In our sample app we store entries with a date and a flag specifying whether this entry is enabled or not. There is no underlying meaning behind these entries. They are meant for learning purposes only. In other applications these entries would be domain specific, e.g. you may store a booking, a favorited track, or a movie.

The DB target contains [EntryRepository](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DB/EntryRepository.swift), a repository containing objects that conform to [Entry](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DB/Entry.swift). Types implementing the Entry and EntryRepository protocols must conform to the [Observable](https://developer.apple.com/documentation/observation/observable) protocol in order for changes to be reflected in SwiftUI Views.

Notice that our EntryRepository protocol contains a property named `models`.

```swift
public protocol EntryRepository: AnyObject, Observable {
    associatedtype EntryType: Entry
    var models: [EntryType] { get }
    func addEntry()
    func deleteEntry(_ entry: EntryType)
    func fetchModels() throws
}
```

Because types implementing the EntryRepository protocol conform to Observable, changes to the `models` property will cause SwiftUI views to update. With this our SwiftUI views no longer need to rely on the `@Query` property wrapper.

The DBSwiftData contains implementations that conform to these protocols, namely [SwiftDataEntry](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DBSwiftData/SwiftDataEntry.swift) and [SwiftDataEntryRepository](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DBSwiftData/SwiftDataEntryRepository.swift). These implementations persist models using SwiftData.

An important detail is that our DBSwiftData target introduces [FetchedResultsController](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DBSwiftData/Internal/FetchedResultsController.swift), a naive implementation of Core Data's [NSFetchedResultsController](https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller) which re-fetches models whenever the data in the store changes. Our [SwiftDataEntryRepository](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DBSwiftData/SwiftDataEntryRepository.swift) uses an instance of FetchedResultsController to back the `models` property.

Continuing our example from earlier, we can now adjust EntryListView to be constructed with a type conforming to EntryRepository and use that to fetch models.

```swift
struct EntryListView<EntryRepositoryType: EntryRepository>: View {
    let entryRepository: EntryRepositoryType

    var body: some View {
        List {
            ForEach(entryRepository.models) { model in
                Text(entry.date, style: \.date)
            }
        }
        .onAppear {
            do {
                try entryRepository.fetchModels()
            } catch {}
        }
    }
}
```

Lastly, we'll need to inject an implementation of EntryRepository into our view. We do this using Dependency Injection by passing the repository to the view through its constructor.

```swift
@main
struct ExampleApp: App {
    private let db: SwiftDataDB

    init() {
        db = SwiftDataDB(isStoredInMemoryOnly: false)
    }

    var body: some Scene {
        WindowGroup {
            EntryListView(
                entryRepository: SwiftDataEntryRepository(
                    modelContext: db.modelContainer.mainContext
                )
            )
        }
    }
}
```

With this we have removed our view's dependency on SwiftData entirely 🙌 

The benefit of decoupling our view and data layers like this is that we now have a codebase where it is straightforward to replace the SwiftData persistence with types that persist in a different database, should we ever want to do so.

## 🤔 Drawbacks

Our implementation of [FetchedResultsController](https://github.com/shapehq/SwiftDataDecoupled/blob/main/DB/Sources/DBSwiftData/Internal/FetchedResultsController.swift) is naive but plays a key part in decoupling SwiftData from the view. Ideally we would like Apple to implement and expose a SwiftData-equivalent of Core Data's NSFetchedResultsController (FB13114301).
