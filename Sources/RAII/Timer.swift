import Foundation

public extension Timer {
    var invalidator: DeinitBlock {
        return DeinitBlock {
            self.invalidate()
        }
    }
}
