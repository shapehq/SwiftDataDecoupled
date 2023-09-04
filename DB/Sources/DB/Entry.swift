import Foundation

public protocol Entry: AnyObject, Identifiable, Equatable, Observable {
    var date: Date { get }
    var isEnabled: Bool { get set }
}
