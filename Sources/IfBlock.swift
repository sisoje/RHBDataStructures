import Foundation

public struct IfBlock {
    public init(_ block: @escaping () -> Bool) {
        self.conditionBlock = block
    }
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
