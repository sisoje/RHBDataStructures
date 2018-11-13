import Foundation

public class MutableWrapper<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

public struct WeakObjectWrapper<T: AnyObject> {
    public private(set) weak var object: T?
    public init(_ object: T) {
        self.object = object
    }
}
