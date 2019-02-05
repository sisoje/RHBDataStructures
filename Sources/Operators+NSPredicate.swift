import Foundation

public protocol TypedPredicateProtocol { associatedtype TP }

public class TypedPredicate<T>: NSPredicate, TypedPredicateProtocol { public typealias TP = T }
public class TypedCompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias TP = T }
public class TypedComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias TP = T }

public func &&<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.TP> where TP1.TP == TP2.TP {
    return TypedCompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func ||<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.TP> where TP1.TP == TP2.TP {
    return TypedCompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func !<TP: NSPredicate & TypedPredicateProtocol>(p: TP) -> TypedCompoundPredicate<TP.TP> {
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

public func ==<E: Equatable, O, K: KeyPath<O, E>>(kp: K, value: E) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.equalTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func !=<E: Equatable, O, K: KeyPath<O, E>>(kp: K, value: E) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.notEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func ><C: Comparable, O, K: KeyPath<O, C>>(kp: K, value: C) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.greaterThan.predicate(leftExpression: kp.asExpression, value: value)
}

public func <<C: Comparable, O, K: KeyPath<O, C>>(kp: K, value: C) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.lessThan.predicate(leftExpression: kp.asExpression, value: value)
}

public func <=<C: Comparable, O, K: KeyPath<O, C>>(kp: K, value: C) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.lessThanOrEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func >=<C: Comparable, O, K: KeyPath<O, C>>(kp: K, value: C) -> TypedComparisonPredicate<O> {
    return NSComparisonPredicate.Operator.greaterThanOrEqualTo.predicate(leftExpression: kp.asExpression, value: value)
}

public func ===<S: Sequence, O, K: KeyPath<O, S.Element>>(kp: K, values: S) -> TypedComparisonPredicate<O> where S.Element: Equatable {
    return NSComparisonPredicate.Operator.in.predicate(leftExpression: kp.asExpression, value: values)
}
