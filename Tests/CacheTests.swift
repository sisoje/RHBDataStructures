import XCTest
import RHBFoundation

final class UIKitTests: XCTestCase {
    func testAlert() {
        let ci = Cache<Int, NSString>()
        ci[5] = "a"
        XCTAssert(ci[5] == "a")
        ci[5] = nil
        XCTAssertNil(ci[5])
    }

    func testAlert2() {
        let ci = Cache<String, NSString>()
        ci["5"] = "a"
        XCTAssert(ci["5"] == "a")
        ci["5"] = nil
        XCTAssertNil(ci["5"])
    }
}
