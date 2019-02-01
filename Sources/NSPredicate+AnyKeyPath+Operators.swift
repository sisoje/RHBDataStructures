import Foundation

extension NSPredicate {
    convenience init(key: String, op: String, value: Any) {
        self.init(format: [key, op, "%@"].joined(separator: " "), argumentArray: [value])
    }
}

extension AnyKeyPath {
    func predicate(_ op: String, _ value: Any) -> NSPredicate {
        return NSPredicate(key: _kvcKeyPathString!, op: op, value: value)
    }
}

public func ==<E: Equatable>(anyKeyPath: AnyKeyPath, value: E) -> NSPredicate {
    return anyKeyPath.predicate("==", value)
}

public func !=<E: Equatable>(anyKeyPath: AnyKeyPath, value: E) -> NSPredicate {
    return !(anyKeyPath == value)
}

public func ><C: Comparable>(anyKeyPath: AnyKeyPath, value: C) -> NSPredicate {
    return anyKeyPath.predicate(">", value)
}

public func <<C: Comparable>(anyKeyPath: AnyKeyPath, value: C) -> NSPredicate {
    return anyKeyPath.predicate("<", value)
}

public func <=<C: Comparable>(anyKeyPath: AnyKeyPath, value: C) -> NSPredicate {
    return anyKeyPath.predicate("<=", value)
}

public func >=<C: Comparable>(anyKeyPath: AnyKeyPath, value: C) -> NSPredicate {
    return anyKeyPath.predicate(">=", value)
}

public func ===<S: Sequence>(anyKeyPath: AnyKeyPath, values: S) -> NSPredicate where S.Element: Equatable {
    return anyKeyPath.predicate("IN", values)
}

public func !==<S: Sequence>(anyKeyPath: AnyKeyPath, values: S) -> NSPredicate where S.Element: Equatable {
    return !(anyKeyPath === values)
}
