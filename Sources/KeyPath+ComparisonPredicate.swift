import Foundation

extension KeyPath {
    func unconstraindedPredicate<V>(_ op: NSComparisonPredicate.Operator, _ value: V) -> ComparisonPredicate<Root> {
        let ex1 = NSExpression(forKeyPath: self)
        let ex2 = NSExpression(forConstantValue: value)
        return ComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}

public extension KeyPath {
    func predicate(_ op: NSComparisonPredicate.Operator, _ value: Value) -> ComparisonPredicate<Root> {
        return unconstraindedPredicate(op, value)
    }
    
    func predicate<T: Sequence>(_ op: NSComparisonPredicate.Operator, _ values: T) -> ComparisonPredicate<Root> where T.Element == Value {
        return unconstraindedPredicate(op, values)
    }
}
