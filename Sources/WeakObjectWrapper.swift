import Foundation

public class WeakObjectWrapper<T: AnyObject> {
    public private(set) weak var weakObject: T?
    public init(_ object: T?) {
        self.weakObject = object
    }
}
