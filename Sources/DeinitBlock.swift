import Foundation

public class DeinitBlock {
    let onDeinit: () -> Void
    public init(_ block: @escaping () -> Void) {
        self.onDeinit = block
    }
    deinit {
        onDeinit()
    }
}

public extension Array where Element == DeinitBlock {
    mutating func append(_ block: @escaping () -> Void) {
        append(DeinitBlock(block))
    }
}
