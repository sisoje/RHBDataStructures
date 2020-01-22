import Foundation

open class Cache<H: Hashable, V: Any> {
    public let nsCache = NSCache<AnyObject, AnyObject>()
    public init() {}
}

public extension Cache {
    subscript(_ h: H) -> V? {
        get {
            nsCache.object(forKey: h as AnyObject) as? V
        }
        set {
            if let v = newValue {
                nsCache.setObject(v as AnyObject, forKey: h as AnyObject)
            } else {
                nsCache.removeObject(forKey: h as AnyObject)
            }
        }
    }
}
