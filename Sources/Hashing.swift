import Foundation

public extension FixedWidthInteger {
    func combine(hash: Self) -> Self {
        return (self << 5) &+ self &+ hash
    }
}

public extension Sequence where Element: Hashable {
    func combinedHash() -> Int {
        return reduce(5381) { $0.combine(hash: $1.hashValue) }
    }
}
