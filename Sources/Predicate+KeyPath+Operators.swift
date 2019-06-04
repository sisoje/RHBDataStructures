import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }
public final class CompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias Root = T }
public final class ComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias Root = T }

public func && <TP: NSPredicate & TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func || <TP: NSPredicate & TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func ! <TP: NSPredicate & TypedPredicateProtocol>(p: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .not, subpredicates: [p])
}

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
    convenience init<VAL>(_ kp: KeyPath<T, VAL>, _ op: NSComparisonPredicate.Operator, _ value: Any?) {
        let ex1 = \T.self == kp ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: kp)
        let ex2 = NSExpression(forConstantValue: value)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}
