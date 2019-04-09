import RHBFoundation
import XCTest

final class IfBlockTests: XCTestCase {
    func testIfDebug() {
        let ex = expectation(description: "expect debug")
        IfBlock.debug.yes {
            assert({ ex.fulfill() }() == {}())
        }
        IfBlock.debug.no {
            assert({ XCTFail() }() == {}())
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testIfSimulator() {
        let ex = expectation(description: "expect simulator")
        IfBlock.simulator.yes {
            XCTAssert(TARGET_OS_SIMULATOR != 0)
            ex.fulfill()
        }
        IfBlock.simulator.no {
            XCTAssert(TARGET_OS_SIMULATOR == 0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testIfMac() {
        let ex = expectation(description: "expect macos")
        IfBlock.macos.yes {
            #if !os(macOS)
                XCTFail()
            #endif
            ex.fulfill()
        }
        IfBlock.macos.no {
            #if os(macOS)
                XCTFail()
            #endif
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testIfIos() {
        let ex = expectation(description: "expect ios")
        IfBlock.ios.yes {
            #if !os(iOS)
                XCTFail()
            #endif
            ex.fulfill()
        }
        IfBlock.ios.no {
            #if os(iOS)
                XCTFail()
            #endif
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testIfNo() {
        let ex = expectation(description: "expect no")
        let testif = IfBlock { false }
        testif.yes {
            XCTFail()
        }
        testif.no {
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testIfYes() {
        let ex = expectation(description: "expect yes")
        let testif = IfBlock { true }
        testif.no {
            XCTFail()
        }
        testif.yes {
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
