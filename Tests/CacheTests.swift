import RHBFoundation
import XCTest

final class CacheTests: XCTestCase {
    enum DummyEnum {
        case ok
        case notok
    }

    func testCacheEnums() {
        let cache = Cache<Int, DummyEnum>()
        cache[0] = .ok
        cache[1] = .notok
        XCTAssertEqual(cache[0], .ok)
        XCTAssertEqual(cache[1], .notok)
    }

    func testCacheByInt() {
        let cache = Cache<Int, String>()
        cache[5] = "a"
        XCTAssert(cache[5] == "a")
        cache[5] = nil
        XCTAssertNil(cache[5])
    }

    func testCacheByString() {
        let cache = Cache<String, String>()
        cache["5"] = "a"
        XCTAssert(cache["5"] == "a")
        cache["5"] = nil
        XCTAssertNil(cache["5"])
    }

    func testRemoveAll() {
        let cache = Cache<Int, String>()
        cache[5] = "a"
        XCTAssert(cache[5] == "a")
        cache.nsCache.removeAllObjects()
        XCTAssertNil(cache[5])
    }
}
