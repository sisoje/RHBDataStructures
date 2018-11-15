import Foundation

public extension Array {
    mutating func grow(to n: Index, _ block: (Index) -> Element) {
        while count < n {
            append(block(count))
        }
    }
    mutating func shrink(to n: Index) {
        while count > n {
            removeLast()
        }
    }
}
