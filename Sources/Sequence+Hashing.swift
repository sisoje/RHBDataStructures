import Foundation

public extension Sequence where Element: Hashable {
    func combinedHash() -> Int {
        return reduce(5381) { $0.combine(hash: $1.hashValue) }
    }
}
