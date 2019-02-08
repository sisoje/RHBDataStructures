import Foundation

public func &&<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> CompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return CompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func ||<TP1: NSPredicate & TypedPredicateProtocol, TP2: NSPredicate & TypedPredicateProtocol>(p1: TP1, p2: TP2) -> CompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    return CompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func !<TP: NSPredicate & TypedPredicateProtocol>(p: TP) -> CompoundPredicate<TP.Root> {
    return CompoundPredicate(type: .not, subpredicates: [p])
}

public func ==<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return kp.predicate(.equalTo, value)
}

public func !=<E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    return kp.predicate(.notEqualTo, value)
}

public func ><C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.greaterThan, value)
}

public func <<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.lessThan, value)
}

public func <=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.lessThanOrEqualTo, value)
}

public func >=<C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    return kp.predicate(.greaterThanOrEqualTo, value)
}

public func ===<S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> ComparisonPredicate<R> where S.Element: Equatable {
    return kp.predicate(.in, values)
}
