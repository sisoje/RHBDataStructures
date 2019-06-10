import Foundation

// MARK: - typed predicate types

public protocol TypedPredicateProtocol: NSPredicate { associatedtype Root }

public final class CompoundPredicate<Root>: NSCompoundPredicate, TypedPredicateProtocol {}

public final class ComparisonPredicate<Root>: NSComparisonPredicate, TypedPredicateProtocol {}

// MARK: - compound operators

public func && <TP: TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func || <TP: TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func ! <TP: TypedPredicateProtocol>(p: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .not, subpredicates: [p])
}

// MARK: - comparison operators

public func == <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .equalTo, value)
}

public func != <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .notEqualTo, value)
}

public func > <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return ComparisonPredicate(kp, .greaterThanOrEqualTo, value)
}

public func === <S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> ComparisonPredicate<R> where S.Element: Equatable {
    return ComparisonPredicate(kp, .in, values)
}

// MARK: - internal

extension ComparisonPredicate {
    convenience init<VAL>(_ kp: KeyPath<Root, VAL>, _ op: NSComparisonPredicate.Operator, _ value: Any?) {
        let ex1 = \Root.self == kp ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: kp)
        let ex2 = NSExpression(forConstantValue: value)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}
