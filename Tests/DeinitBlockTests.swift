import XCTest
import RHBFoundation

final class DeinitBlockTests: XCTestCase {
    func testBlockDeinitBlock() {
        var t = 0
        _ = {
            XCTAssert(t == 0)
            _ = DeinitBlock { t = 1 }
        }()
        XCTAssert(t == 1)
    }

    func testBlockDeinitBlockArray() {
        var t = 0
        _ = {
            XCTAssert(t == 0)
            var m: [DeinitBlock] = []
            m.append ( DeinitBlock { t = 1 } )
        }()
        XCTAssert(t == 1)
    }
}
