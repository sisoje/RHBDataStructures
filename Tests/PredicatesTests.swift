import RHBFoundation
import XCTest

func filt<T>(_ arr: [T], _ pred: NSPredicate) -> [T] {
    return (arr as NSArray).filtered(using: pred) as! [T]
}

final class PredicatesTests: XCTestCase {
    let arr = [1, 2, 3, 4]
    let numberKeyPath = \NSNumber.intValue

    func testBuildingPredicates() {
        XCTAssertEqual(filt(arr, numberKeyPath == 1), [1])
        XCTAssertEqual(filt(arr, numberKeyPath != 1), [2, 3, 4])
        XCTAssertEqual(filt(arr, numberKeyPath > 3), [4])
        XCTAssertEqual(filt(arr, numberKeyPath < 2), [1])
        XCTAssertEqual(filt(arr, numberKeyPath >= 4), [4])
        XCTAssertEqual(filt(arr, numberKeyPath <= 1), [1])
        XCTAssertEqual(filt(arr, numberKeyPath === [0, 1]), [1])
        XCTAssertEqual(filt(arr, !(numberKeyPath === [2, 3, 4, 5])), [1])
    }

    func testCombinePredicates() {
        XCTAssertEqual(filt(arr, numberKeyPath == 1 || numberKeyPath == 2), [1, 2])
        XCTAssertEqual(filt(arr, numberKeyPath > 1 && numberKeyPath < 3), [2])
        XCTAssertEqual(filt(arr, !(numberKeyPath > 1)), [1])
    }

    func testKeypath4() {
        XCTAssertEqual(filt(arr, \NSNumber.stringValue == "1"), [1])
    }
}
