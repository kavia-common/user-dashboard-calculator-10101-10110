import Foundation

#if canImport(CalculatorCore)
import CalculatorCore
#endif

@MainActor
final class CalculatorViewModel: ObservableObject {
    enum Operation: String, CaseIterable, Identifiable {
        case add = "Add"
        case subtract = "Subtract"
        case multiply = "Multiply"
        case divide = "Divide"

        var id: String { rawValue }
    }

    @Published var leftValueText: String = ""
    @Published var rightValueText: String = ""
    @Published var operation: Operation = .add

    @Published private(set) var resultText: String = "—"
    @Published private(set) var errorText: String?

    private let calculator: CalculatorProtocol = {
        #if canImport(CalculatorCore)
        return CalculatorCoreAdapter()
        #else
        return FallbackCalculator()
        #endif
    }()

    func clear() {
        leftValueText = ""
        rightValueText = ""
        resultText = "—"
        errorText = nil
        operation = .add
    }

    func compute() {
        errorText = nil

        guard let a = Double(leftValueText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            errorText = "Enter a valid first number."
            return
        }
        guard let b = Double(rightValueText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            errorText = "Enter a valid second number."
            return
        }

        do {
            let value: Double
            switch operation {
            case .add:
                value = calculator.add(a, b)
            case .subtract:
                value = calculator.subtract(a, b)
            case .multiply:
                value = calculator.multiply(a, b)
            case .divide:
                value = try calculator.divide(a, b)
            }

            resultText = Self.format(value)
        } catch {
            errorText = error.localizedDescription
            resultText = "—"
        }
    }

    private static func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

private protocol CalculatorProtocol {
    func add(_ a: Double, _ b: Double) -> Double
    func subtract(_ a: Double, _ b: Double) -> Double
    func multiply(_ a: Double, _ b: Double) -> Double
    func divide(_ a: Double, _ b: Double) throws -> Double
}

#if canImport(CalculatorCore)
private struct CalculatorCoreAdapter: CalculatorProtocol {
    private let core = Calculator()

    func add(_ a: Double, _ b: Double) -> Double { core.add(a, b) }
    func subtract(_ a: Double, _ b: Double) -> Double { core.subtract(a, b) }
    func multiply(_ a: Double, _ b: Double) -> Double { core.multiply(a, b) }
    func divide(_ a: Double, _ b: Double) throws -> Double { try core.divide(a, b) }
}
#endif

/// Fallback calculator used when `CalculatorCore` isn't available (e.g., when the package dependency hasn't been added yet).
private struct FallbackCalculator: CalculatorProtocol {
    func add(_ a: Double, _ b: Double) -> Double { a + b }
    func subtract(_ a: Double, _ b: Double) -> Double { a - b }
    func multiply(_ a: Double, _ b: Double) -> Double { a * b }
    func divide(_ a: Double, _ b: Double) throws -> Double {
        if b == 0 { throw NSError(domain: "Calculator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot divide by zero."]) }
        return a / b
    }
}
