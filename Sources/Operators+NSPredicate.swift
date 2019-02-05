import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }

public class TypedPredicate<T>: NSPredicate, TypedPredicateProtocol { public typealias Root = T }
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

extension NSComparisonPredicate.Operator {
    func predicate<T>(leftExpression: NSExpression, value: Any?) -> TypedComparisonPredicate<T> {
        let rightExpression = NSExpression(forConstantValue: value)
        return TypedComparisonPredicate(leftExpression: leftExpression, rightExpression: rightExpression, modifier: .direct, type: self)
    }
}

extension KeyPath {
    var asExpression: NSExpression {
        return NSExpression(forKeyPath: self)
    }
}

public func ==<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.equalTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func !=<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.notEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func ><C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.greaterThan.predicate(leftExpression: kp.asExpression, value: value)
}

public func <<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.lessThan.predicate(leftExpression: kp.asExpression, value: value)
}

public func <=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.lessThanOrEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func >=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    return NSComparisonPredicate.Operator.greaterThanOrEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func ===<S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> TypedComparisonPredicate<R> where S.Element: Equatable {
    return NSComparisonPredicate.Operator.in.predicate(leftExpression: kp.asExpression, value: values)
}
