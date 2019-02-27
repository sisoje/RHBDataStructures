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
