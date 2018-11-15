import Foundation

public class MutableValueWrapper<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}
