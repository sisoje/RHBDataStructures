import Foundation

public class MutableValueWrapper<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

public struct WeakObjectWrapper<T: AnyObject> {
    public private(set) weak var object: T?
    public init(_ object: T) {
        self.object = object
    }
}

public class Deiniter {
    let onDeinit: () -> Void
    public init(_ block: @escaping () -> Void) {
        onDeinit = block
    }
    deinit {
        onDeinit()
    }
}

public extension Array where Element == Deiniter {
    mutating func append(_ block: @escaping () -> Void) {
        append(Deiniter(block))
    }
}

public struct IfBlock {
    public let conditionBlock: () -> Bool
    public func yes(_ block: () -> Void) {
        if conditionBlock() {
            block()
        }
    }
    public func no(_ block: () -> Void) {
        if !conditionBlock() {
            block()
        }
    }
}

public let IfDebug = IfBlock {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

public let IfSimulator = IfBlock {
    return TARGET_OS_SIMULATOR != 0
}
