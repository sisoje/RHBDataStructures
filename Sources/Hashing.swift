import Foundation

public func combineHashValue<T: FixedWidthInteger>(_ h1: T, _ h2: T) -> T {
    return (h1 << 5) &+ h1 &+ h2
}

public extension Sequence where Element: Hashable {
    func combinedHashValue() -> Int {
        return reduce(5381) { combineHashValue($0, $1.hashValue) }
    }
}
