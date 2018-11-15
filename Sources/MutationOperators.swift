import Foundation

precedencegroup MutationPrecedence {
    higherThan: MultiplicationPrecedence
    associativity: left
}

infix operator ~~~: MutationPrecedence
infix operator ~~: MutationPrecedence

@discardableResult
public func mutateBlock<T>(_ value: T, _ block: (T) -> Void) -> T {
    block(value)
    return value
}

@discardableResult
public func mutateBlock<T>(_ value: T?, _ block: (T) -> Void) -> T? {
    if let value = value {
        block(value)
    }
    return value
}

public func ~~<U: AnyObject>(object: U, block: (U) -> Void) -> U {
    return mutateBlock(object, block)
}

public func ~~<U: AnyObject>(optional: U?, block: (U) -> Void) -> U? {
    return mutateBlock(optional, block)
}

public func ~~<U>(optional: U?, block: (U) -> Void) {
    mutateBlock(optional, block)
}

public func ~~~<U>(value: U, block: (MutableValueWrapper<U>) -> Void) -> U {
    return mutateBlock(MutableValueWrapper(value), block).value
}
