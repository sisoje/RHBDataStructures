import RHBFoundation
import XCTest

final class CollectionExtensionsTests: XCTestCase {
    func testEmpty() {
        let emptyArray = [Int]()
        (-1...1).forEach {
            XCTAssertNil(emptyArray[safe: $0])
        }
    }

    func testValidValues() {
        let someArray = [1, 2, 3]
        someArray.enumerated().forEach { index, val in
            XCTAssert(someArray[safe: index] == val)
        }
    }
}
