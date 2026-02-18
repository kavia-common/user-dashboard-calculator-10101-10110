import Foundation
import CalculatorCore

let calculator = Calculator()

print("demo: CalculatorCore")
print("2 + 3 = \(calculator.add(2, 3))")
print("7 - 4 = \(calculator.subtract(7, 4))")
print("6 * 5 = \(calculator.multiply(6, 5))")

do {
    print("10 / 2 = \(try calculator.divide(10, 2))")
} catch {
    print("division error: \(error.localizedDescription)")
}

// Keep the demo short-lived; this is just a smoke-check binary.
