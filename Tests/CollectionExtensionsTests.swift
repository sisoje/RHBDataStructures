import XCTest
import RHBFoundation

final class CollectionExtensionsTests: XCTestCase {
    func testEmpty() {
        let emptyArray = [Int]()
        XCTAssertNil(emptyArray[safe: 0])
        XCTAssertNil(emptyArray[safe: -1])
        XCTAssertNil(emptyArray[safe: 1])
    }

    func testEdgeCases() {
        let someArray = [1,2,3]
        XCTAssertNil(someArray[safe: -1])
        XCTAssertNil(someArray[safe: someArray.count])
        XCTAssertNotNil(someArray[safe: 0])
        XCTAssertNotNil(someArray[safe: someArray.count-1])
    }
}
