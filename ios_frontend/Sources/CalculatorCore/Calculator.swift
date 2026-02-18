import Foundation

/// Core calculator operations used by the app/dashboard.
///
/// This module is intentionally UI-agnostic so it can be compiled and tested in
/// a headless (Linux) environment.
public struct Calculator {
    public init() {}

    public func add(_ a: Double, _ b: Double) -> Double { a + b }
    public func subtract(_ a: Double, _ b: Double) -> Double { a - b }
    public func multiply(_ a: Double, _ b: Double) -> Double { a * b }

    /// Divides `a` by `b`.
    /// - Throws: `CalculatorError.divideByZero` if `b == 0`.
    public func divide(_ a: Double, _ b: Double) throws -> Double {
        guard b != 0 else { throw CalculatorError.divideByZero }
        return a / b
    }
}

public enum CalculatorError: Error, LocalizedError, Equatable {
    case divideByZero

    public var errorDescription: String? {
        switch self {
        case .divideByZero:
            return "Cannot divide by zero."
        }
    }
}
