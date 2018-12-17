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
