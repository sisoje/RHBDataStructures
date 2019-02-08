import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }

public class CompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias Root = T }

public class ComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias Root = T }
