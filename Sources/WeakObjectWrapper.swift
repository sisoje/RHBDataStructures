import Foundation

public class WeakObjectWrapper<T: AnyObject> {
    public private(set) weak var object: T?
    public init(_ object: T?) {
        self.object = object
    }
}
