import Foundation

public extension KeyPath {
    func predicate(_ op: NSComparisonPredicate.Operator, _ value: Value) -> ComparisonPredicate<Root> {
        let ex1 = NSExpression(forKeyPath: self)
        let ex2 = NSExpression(forConstantValue: value)
        return ComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
    
    func predicate<T: Sequence>(_ op: NSComparisonPredicate.Operator, _ values: T) -> ComparisonPredicate<Root> where T.Element == Value {
        let ex1 = NSExpression(forKeyPath: self)
        let ex2 = NSExpression(forConstantValue: values)
        return ComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}
