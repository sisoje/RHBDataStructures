import Foundation

public struct WeakObjectWrapper<T: AnyObject> {
    public weak var object: T?
    public init(_ object: T) {
        self.object = object
    }
}
