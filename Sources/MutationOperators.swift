import Foundation

infix operator ~~: MultiplicationPrecedence
infix operator ~: MultiplicationPrecedence


@discardableResult
public func ~<U: AnyObject>(object: U, block: (U) -> Void) -> U {
    block(object)
    return object
}

public func ~~<U>(value: U, block: (MutableValueWrapper<U>) -> Void) -> U {
    return (MutableValueWrapper(value) ~ block).mutableValue
}
