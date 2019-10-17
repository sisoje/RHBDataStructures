import Foundation

open class Cache<H: Hashable, V: AnyObject> {
    public let cache = NSCache<AnyObject, V>()

    public init() {}
}

public extension Cache {
    func removeAllObjects() {
        cache.removeAllObjects()
    }

    subscript(_ h: H) -> V? {
        get {
            cache.object(forKey: h as AnyObject)
        }
        set {
            if let v = newValue {
                cache.setObject(v, forKey: h as AnyObject)
            } else {
                cache.removeObject(forKey: h as AnyObject)
            }
        }
    }
}
