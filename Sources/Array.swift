import Foundation

public extension Array {
    mutating func grow(to n: Index, _ block: (Index) -> Element) {
        while count < n {
            append(block(count))
        }
    }
    func grown(to n: Index, _ block: (Index) -> Element) -> Array {
        return self ~~~ { $0.value.grow(to: n, block) }
    }
}
