import Foundation

public extension Array {
    mutating func grow(to n: Index, _ block: () -> Element) {
        while count < n {
            append(block())
        }
    }
    mutating func shrink(to n: Index) {
        while count > n {
            removeLast()
        }
    }
    init(size: Index, _ block: () -> Element) {
        self.init()
        grow(to: size, block)
    }
}
