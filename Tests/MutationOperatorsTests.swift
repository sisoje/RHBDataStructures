import XCTest
import RHBFoundation

final class MutationOperatorsTests: XCTestCase {
    func testObjects() {
        let arr = NSMutableArray() ~ { $0.add(NSObject()) }
        XCTAssert(arr.count == 1)

        let oq = OperationQueue() ~ {
            XCTAssert($0.maxConcurrentOperationCount != 1)
            $0.maxConcurrentOperationCount = 1
        }
        XCTAssert(oq.maxConcurrentOperationCount == 1)
    }
}
