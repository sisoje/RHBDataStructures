import Foundation

public extension FixedWidthInteger {
    func combine(hash: Self) -> Self {
        return (self << 5) &+ self &+ hash
    }
}
