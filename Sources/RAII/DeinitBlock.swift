import Foundation

public class DeinitBlock {
    let onDeinit: () -> Void
    public init(_ block: @escaping () -> Void) {
        onDeinit = block
    }
    deinit {
        onDeinit()
    }
}
