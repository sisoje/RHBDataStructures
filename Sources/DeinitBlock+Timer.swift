import Foundation

public extension Timer {
    var invalidator: DeinitBlock {
        return DeinitBlock { [weak self] in
            self?.invalidate()
        }
    }
}
