import Foundation

infix operator ~: MultiplicationPrecedence

@discardableResult
public func ~<U: AnyObject>(object: U, block: (U) -> Void) -> U {
    block(object)
    return object
}
