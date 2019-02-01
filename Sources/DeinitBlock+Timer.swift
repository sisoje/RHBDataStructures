import Foundation

public extension Timer {
    var invalidation: DeinitBlock {
        return DeinitBlock { [weak self] in
            self?.invalidate()
        }
    }
}
