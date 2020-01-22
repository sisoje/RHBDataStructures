import RHBFoundation
import XCTest

final class OptionalTests: XCTestCase {
    let swiftDic = [String: Int]()

    func testForceUnwrap() {
        XCTAssertNoThrow(
            XCTAssertEqual(try Optional(swiftDic).forceUnwrap(), swiftDic)
        )
    }

    func testForceUnwrapThrow() {
        XCTAssertThrowsError(
            try swiftDic.first.forceUnwrap()
        )
    }

    func testForceCast() {
        XCTAssertNoThrow(
            XCTAssertEqual(try Optional(NSDictionary(dictionary: swiftDic)).forceCast(as: [String: Int].self), swiftDic)
        )
    }

    func testForceCastThrow() {
        XCTAssertThrowsError(
            try swiftDic.first.forceCast(as: String.self)
        )
    }
}
