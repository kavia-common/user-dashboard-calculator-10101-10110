import XCTest
@testable import CalculatorCore

final class CalculatorCoreTests: XCTestCase {
    func testAdd() {
        XCTAssertEqual(Calculator().add(2, 3), 5)
    }

    func testDivide() throws {
        XCTAssertEqual(try Calculator().divide(10, 2), 5)
    }

    func testDivideByZeroThrows() {
        XCTAssertThrowsError(try Calculator().divide(10, 0)) { error in
            XCTAssertEqual(error as? CalculatorError, .divideByZero)
        }
    }
}
