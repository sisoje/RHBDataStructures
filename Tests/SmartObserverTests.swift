import XCTest
import RHBFoundation

final class SmartObserverTests: XCTestCase {
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
