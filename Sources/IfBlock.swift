import Foundation

public struct IfBlock {
    let conditionBlock: () -> Bool
    public init(_ block: @escaping () -> Bool) {
        conditionBlock = block
    }
}

public extension IfBlock {
    func yes(_ block: () -> Void) {
        if conditionBlock() {
            block()
        }
    }

    func no(_ block: () -> Void) {
        if !conditionBlock() {
            block()
        }
    }
}

public extension IfBlock {
    static let debug = IfBlock {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static let simulator = IfBlock {
        TARGET_OS_SIMULATOR != 0
    }

    static let macos = IfBlock {
        #if os(macOS)
            return true
        #else
            return false
        #endif
    }

    static let ios = IfBlock {
        #if os(iOS)
            return true
        #else
            return false
        #endif
    }
}
