import XCTest
import RHBFoundation

final class DeinitBlockTests: XCTestCase {
    func testDeinitBlock() {
        var t = 0
        _ = DeinitBlock {
            XCTAssert(t == 0)
            t = 1
        }
        XCTAssert(t == 1)
    }

    func testDeinitBlock2() {
        var t = 0
        var d: DeinitBlock? = DeinitBlock {
            XCTAssert(t == 0)
            t = 1
        }
        XCTAssert(t == 0)
        d?.noop()
        XCTAssert(t == 0)
        d = nil
        XCTAssert(t == 1)
    }

    func testNotificationCenter() {
        let notificationName = NSNotification.Name("testNotificationCenter")
        let exp = self.expectation(description: notificationName.rawValue)
        var rm: DeinitBlock?
        rm = NotificationCenter.default.addSmartObserver(name: notificationName) { _ in
            XCTAssertNotNil(rm)
            rm = nil
            exp.fulfill()
        }
        OperationQueue().addOperation {
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}
