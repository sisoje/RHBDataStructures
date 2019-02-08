import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }

public class TypedCompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias Root = T }
public class TypedComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias Root = T }

public func &&<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return TypedCompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func ||<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return TypedCompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func !<TP: NSPredicate & TypedPredicateProtocol>(p: TP) -> TypedCompoundPredicate<TP.Root> {
    return TypedCompoundPredicate(type: .not, subpredicates: [p])
}

extension KeyPath {
    func predicate(_ op: NSComparisonPredicate.Operator, _ value: Any?) -> TypedComparisonPredicate<Root> {
        let ex1 = NSExpression(forKeyPath: self)
        let ex2 = NSExpression(forConstantValue: value)
        return TypedComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}

public func ==<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    return kp.predicate(.equalTo, value)
}

public func !=<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    return kp.predicate(.notEqualTo, value)
}

public func ><C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return kp.predicate(.greaterThan, value)
}

public func <<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return kp.predicate(.lessThan, value)
}

public func <=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return kp.predicate(.lessThanOrEqualTo, value)
}

public func >=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return kp.predicate(.greaterThanOrEqualTo, value)
}

public func ===<S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> TypedComparisonPredicate<R> where S.Element: Equatable {
    return kp.predicate(.in, values)
}
