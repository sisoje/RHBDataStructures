import Foundation

precedencegroup MutationPrecedence {
    higherThan: MultiplicationPrecedence
    associativity: left
}

infix operator ~~~: MutationPrecedence
infix operator ~~: MutationPrecedence

public extension MutableValueWrapper {
    func mutated(_ block: (MutableValueWrapper<T>) -> Void) -> T {
        block(self)
        return value
    }
}

public func optionalBlock<T>(_ optional: T?, _ block: (T) -> Void) {
    if let value = optional {
        block(value)
    }
}

public func ~~<U: AnyObject>(object: U, block: (U) -> Void) -> U {
    block(object)
    return object
}

public func ~~<U: AnyObject>(optional: U?, block: (U) -> Void) -> U? {
    optionalBlock(optional, block)
    return optional
}

public func ~~<U>(optional: U?, block: (U) -> Void) {
    optionalBlock(optional, block)
}

public func ~~~<U>(value: U, block: (MutableValueWrapper<U>) -> Void) -> U {
    return MutableValueWrapper(value).mutated(block)
}
