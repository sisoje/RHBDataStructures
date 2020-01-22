import Foundation

public extension DispatchQueue {
    func syncMain<T>(_ block: () throws -> T) rethrows -> T {
        guard self == .main, Thread.isMainThread else {
            return try sync(execute: block)
        }
        return try block()
    }
}
