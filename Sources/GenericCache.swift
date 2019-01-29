import Foundation

open class GenericCache<H: Hashable, V: AnyObject> {
    public let nsCache = NSCache<AnyObject, V>()
    public init() {}
}

public extension GenericCache {
    func set(key h: H, object v: V, cost: Int) {
        nsCache.setObject(v, forKey: h as AnyObject, cost: cost)
    }
    subscript(_ h: H) -> V? {
        get {
            return nsCache.object(forKey: h as AnyObject)
        }
        set {
            if let v = newValue {
                nsCache.setObject(v, forKey: h as AnyObject)
            } else {
                nsCache.removeObject(forKey: h as AnyObject)
            }
        }
    }
}
