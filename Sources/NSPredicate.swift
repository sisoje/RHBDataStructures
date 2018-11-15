import Foundation

public extension NSPredicate {
    convenience init(key: String, op: String, value: Any) {
        self.init(format: [key, op, "%@"].joined(separator: " "), argumentArray: [value])
    }
}

public func &&(p1: NSPredicate, p2: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
}

public func ||(p1: NSPredicate, p2: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
}

public prefix func !(p: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(notPredicateWithSubpredicate: p)
}
