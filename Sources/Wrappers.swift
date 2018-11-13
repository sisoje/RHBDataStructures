import Foundation

public class MutableValueWrapper<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

public class WeakObjectWrapper<T: AnyObject> {
    public private(set) weak var object: T?
    public init(_ object: T) {
        self.object = object
    }
}
