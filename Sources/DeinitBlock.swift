import Foundation

public class DeinitBlock {
    let onDeinit: () -> Void
    public init(onDeinit block: @escaping () -> Void) {
        self.onDeinit = block
    }
    deinit {
        onDeinit()
    }
}

public extension Array where Element == DeinitBlock {
    mutating func append(_ block: @escaping () -> Void) {
        append(DeinitBlock(onDeinit: block))
    }
}
