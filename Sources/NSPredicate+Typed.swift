import Foundation

public protocol TypedPredicateProtocol { associatedtype Root }
public class CompoundPredicate<T>: NSCompoundPredicate, TypedPredicateProtocol { public typealias Root = T }
public class ComparisonPredicate<T>: NSComparisonPredicate, TypedPredicateProtocol { public typealias Root = T }

public extension ComparisonPredicate {
    convenience init<S: Sequence>(inValues values: S) where S.Element == T {
        let ex1 = NSExpression(format: "self")
        let ex2 = NSExpression(forConstantValue: values)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: .in)
    }
}
