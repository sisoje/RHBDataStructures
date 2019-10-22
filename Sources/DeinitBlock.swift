import Foundation

public final class DeinitBlock {
    let onDeinit: () -> Void

    public init(_ onDeinit: @escaping () -> Void) {
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}

public extension DeinitBlock {
    func noop() {}
}
