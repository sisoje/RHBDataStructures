import XCTest
import RHBFoundation

public extension XCTestExpectation {
    var fulfiller: DeinitBlock {
        return DeinitBlock {
            self.fulfill()
        }
    }
}
