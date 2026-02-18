import SwiftUI

struct CalculatorCardView: View {
    @StateObject private var viewModel = CalculatorViewModel()

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Calculator")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.text)
                    Spacer()
                    Button("Clear") {
                        viewModel.clear()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.primary)
                    .accessibilityLabel("Clear calculator")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("First number")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    TextField("0", text: $viewModel.leftValueText)
                        .keyboardType(.decimalPad)
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Text("Operation")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    Picker("Operation", selection: $viewModel.operation) {
                        ForEach(CalculatorViewModel.Operation.allCases) { op in
                            Text(op.rawValue).tag(op)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text("Second number")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    TextField("0", text: $viewModel.rightValueText)
                        .keyboardType(.decimalPad)
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                PrimaryButton(title: "Compute") {
                    viewModel.compute()
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Result")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    Text(viewModel.resultText)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(AppTheme.text)
                        .accessibilityLabel("Result: \(viewModel.resultText)")

                    if let error = viewModel.errorText {
                        Text(error)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.error)
                            .padding(.top, 2)
                            .accessibilityLabel("Calculation error: \(error)")
                    }
                }
                .padding(.top, 2)
            }
        }
    }
}
