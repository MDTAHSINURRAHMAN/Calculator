import SwiftUI

struct ContentView: View {
    @State private var displayText = "0"
    @State private var currentNumber: Double = 0
    @State private var previousNumber: Double = 0
    @State private var currentOperation: Operation? = nil

    let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .operation(.divide)],
        [.number(7), .number(8), .number(9), .operation(.multiply)],
        [.number(4), .number(5), .number(6), .operation(.subtract)],
        [.number(1), .number(2), .number(3), .operation(.add)],
        [.number(0), .decimal, .equals]
    ]

    var body: some View {
        VStack {
            Spacer()
            
            // Display
            HStack {
                Spacer()
                Text(displayText)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()
            }
            .background(Color.white)
            
            // Buttons
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.didTap(button)
                        }) {
                            Text(button.title)
                                .font(.title)
                                .frame(width: self.buttonWidth(button: button),
                                       height: self.buttonHeight())
                                .background(button.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .padding()
    }

    // Button Tap Handler
    private func didTap(_ button: CalculatorButton) {
        switch button {
        case .number(let value):
            if displayText == "0" || displayText == "+" || displayText == "-" || displayText == "×" || displayText == "÷" {
                displayText = "\(value)"
            } else {
                displayText += "\(value)"
            }
            currentNumber = Double(displayText) ?? 0
        case .decimal:
            if !displayText.contains(".") {
                displayText += "."
            }
        case .operation(let operation):
            previousNumber = currentNumber
            currentOperation = operation
            displayText = operation.rawValue
        case .equals:
            guard let operation = currentOperation else { return }
            let result = calculateResult(operation: operation)
            displayText = "\(result)"
            currentNumber = result
            previousNumber = 0
            currentOperation = nil
        case .clear:
            displayText = "0"
            currentNumber = 0
            previousNumber = 0
            currentOperation = nil
        case .negative:
            currentNumber = -currentNumber
            displayText = "\(currentNumber)"
        case .percent:
            currentNumber = currentNumber / 100
            displayText = "\(currentNumber)"
        }
    }
    
    private func calculateResult(operation: Operation) -> Double {
        switch operation {
        case .add: return previousNumber + currentNumber
        case .subtract: return previousNumber - currentNumber
        case .multiply: return previousNumber * currentNumber
        case .divide: return previousNumber / currentNumber
        }
    }

    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        return button == .number(0) ? (UIScreen.main.bounds.width - 50) / 2 : (UIScreen.main.bounds.width - 60) / 4
    }

    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 60) / 4
    }
}

enum CalculatorButton: Hashable {
    case number(Int)
    case operation(Operation)
    case equals, clear, negative, percent, decimal
    
    var title: String {
        switch self {
        case .number(let value): return "\(value)"
        case .operation(let op): return op.rawValue
        case .equals: return "="
        case .clear: return "C"
        case .negative: return "±"
        case .percent: return "%"
        case .decimal: return "."
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .operation, .equals:
            return Color.orange
        case .clear, .negative, .percent:
            return Color.gray
        default:
            return Color.gray.opacity(0.4)
        }
    }
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "×"
    case divide = "÷"
}

