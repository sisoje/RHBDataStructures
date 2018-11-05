import XCTest
@testable import RHBDataStructures

final class RHBDataStructuresTests: XCTestCase {
    static var allTests = [
        ("testWeakWrapperRetained", testWeakWrapperRetained),
        ("testWeakWrapperUnretained", testWeakWrapperUnretained),
        ("testWeakWrapperNullability", testWeakWrapperNullability),
        ("testWeakWrapperScope", testWeakWrapperScope),
    ]
    func testWeakWrapperRetained() {
        let object = NSObject()
        let container = WeakObjectWrapper(object)
        XCTAssertEqual(object, container.object)
    }
    func testWeakWrapperUnretained() {
        let container = WeakObjectWrapper(NSObject())
        XCTAssertNil(container.object)
    }
    func testWeakWrapperNullability() {
        var object: NSObject! = NSObject()
        let container = WeakObjectWrapper(object)
        XCTAssertNotNil(container.object)
        XCTAssertEqual(object, container.object)
        object = nil
        XCTAssertNil(container.object)
    }
    func testWeakWrapperScope() {
        let container: WeakObjectWrapper<NSObject> = {
            let object: NSObject = NSObject()
            let container = WeakObjectWrapper(object)
            XCTAssertNotNil(container.object)
            XCTAssertEqual(object, container.object)
            return container
        }()
        XCTAssertNil(container.object)
    }
}
