import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }
public class CompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias Root = T }
public class ComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias Root = T }

public extension KeyPath {
    internal func unconstraindedPredicate(_ op: NSComparisonPredicate.Operator, _ value: Any?) -> ComparisonPredicate<Root> {
        let ex1 = self == \Root.self ? NSExpression(format: "self") : NSExpression(forKeyPath: self)
        let ex2 = NSExpression(forConstantValue: value)
        return ComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }

    func predicate(_ op: NSComparisonPredicate.Operator, _ value: Value) -> ComparisonPredicate<Root> {
        return unconstraindedPredicate(op, value)
    }

    func predicate<T: Sequence>(_ op: NSComparisonPredicate.Operator, _ values: T) -> ComparisonPredicate<Root> where T.Element == Value {
        return unconstraindedPredicate(op, values)
    }
}

public func && <TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> CompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return CompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func || <TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> CompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return CompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func ! <TP: NSPredicate & TypedPredicateProtocol>(p: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .not, subpredicates: [p])
}

public func == <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return kp.predicate(.equalTo, value)
}

public func != <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return kp.predicate(.notEqualTo, value)
}

public func > <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.greaterThanOrEqualTo, value)
}

public func === <S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> ComparisonPredicate<R> where S.Element: Equatable {
    return kp.predicate(.in, values)
}
