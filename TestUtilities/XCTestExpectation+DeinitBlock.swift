import RHBFoundation
import XCTest

public extension XCTestExpectation {
    var fulfiller: DeinitBlock {
        return DeinitBlock {
            self.fulfill()
        }
    }
}
