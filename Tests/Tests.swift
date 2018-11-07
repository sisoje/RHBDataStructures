import XCTest
import RHBDataStructures

final class RHBDataStructuresTests: XCTestCase {
    func testWeakObjectWrapperRetained() {
        let object = NSObject()
        let container = WeakObjectWrapper(object)
        XCTAssertEqual(object, container.object)
    }
    func testWeakObjectWrapperUnretained() {
        let container = WeakObjectWrapper(NSObject())
        XCTAssertNil(container.object)
    }
    func testWeakObjectWrapperNullability() {
        var object: NSObject! = NSObject()
        let container = WeakObjectWrapper(object)
        XCTAssertNotNil(container.object)
        XCTAssertEqual(object, container.object)
        object = nil
        XCTAssertNil(container.object)
    }
    func testWeakObjectWrapperScope() {
        let container: WeakObjectWrapper<NSObject> = {
            let object: NSObject = NSObject()
            let container = WeakObjectWrapper(object)
            XCTAssertNotNil(container.object)
            XCTAssertEqual(object, container.object)
            return container
        }()
        XCTAssertNil(container.object)
    }
    func testDeiniter() {
        var t = 0
        _ = {
            XCTAssert(t == 0)
            _ = Deiniter { t = 1 }
        }()
        XCTAssert(t == 1)
    }
    func testDeiniterArray() {
        var t = 0
        _ = {
            XCTAssert(t == 0)
            var m: [Deiniter] = []
            m.append { t = 1 }
        }()
        XCTAssert(t == 1)
    }
    func testIfBlock() {
        IfDebug.yes {
            #if !DEBUG
            XCTFail()
            #endif
        }
        IfDebug.no {
            #if DEBUG
            XCTFail()
            #endif
        }
    }
}
