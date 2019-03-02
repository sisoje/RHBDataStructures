import RHBFoundation
import XCTest

final class CacheTests: XCTestCase {
    func testCacheByInt() {
        let cache = Cache<Int, NSString>()
        cache[5] = "a"
        XCTAssert(cache[5] == "a")
        cache[5] = nil
        XCTAssertNil(cache[5])
    }

    func testCacheByString() {
        let cache = Cache<String, NSString>()
        cache["5"] = "a"
        XCTAssert(cache["5"] == "a")
        cache["5"] = nil
        XCTAssertNil(cache["5"])
    }
}
