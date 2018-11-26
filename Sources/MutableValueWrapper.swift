import Foundation

public class MutableValueWrapper<T> {
    public var mutableValue: T
    public init(_ value: T) {
        self.mutableValue = value
    }
}
