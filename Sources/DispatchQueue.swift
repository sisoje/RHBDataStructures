import Foundation

public extension DispatchQueue {
    func mainSync<T>(_ block: ()->T) -> T {
        guard self == .main, Thread.isMainThread else {
            return sync(execute: block)
        }
        return block()
    }
}
