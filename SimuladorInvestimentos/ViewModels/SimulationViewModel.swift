import Foundation
import Observation

public enum PeriodType: String, CaseIterable, Identifiable {
    case years = "Anos"
    case months = "Meses"
    public var id: String { rawValue }
}

@Observable
public final class SimulationViewModel {
    public var initialAmountString = "1000" { didSet { invalidateResult() } }
    public var monthlyContributionString = "200" { didSet { invalidateResult() } }
    public var annualRateString = "12" { didSet { invalidateResult() } }
    public var periodValueString = "5" { didSet { invalidateResult() } }
    public var periodType: PeriodType = .years { didSet { invalidateResult() } }
    public var result: InvestmentResult?
    public var validationError: String?

    private let calculator: InvestmentCalculator

    public init(calculator: InvestmentCalculator = InvestmentCalculator()) {
        self.calculator = calculator
    }

    public var parsedInitialAmount: Double? { Self.parseBrazilianNumber(initialAmountString) }
    public var parsedMonthlyContribution: Double? { Self.parseBrazilianNumber(monthlyContributionString) }
    public var parsedAnnualRate: Double? { Self.parseBrazilianNumber(annualRateString) }
    public var parsedPeriodValue: Int? {
        let text = periodValueString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.range(of: "^[0-9]+$", options: .regularExpression) != nil else { return nil }
        return Int(text)
    }

    public var periodInMonths: Int? {
        guard let value = parsedPeriodValue, value > 0 else { return nil }
        switch periodType {
        case .years:
            guard value <= 50 else { return nil }
            return value * 12
        case .months:
            guard value <= 600 else { return nil }
            return value
        }
    }

    /// The same validation drives the button, inline feedback and calculation.
    public var inputValidationMessage: String? {
        guard let initial = parsedInitialAmount, (0...1_000_000_000).contains(initial) else {
            return "Informe um valor inicial entre R$ 0,00 e R$ 1.000.000.000,00. Use vírgula para centavos."
        }
        guard let monthly = parsedMonthlyContribution, (0...1_000_000_000).contains(monthly) else {
            return "Informe um aporte mensal entre R$ 0,00 e R$ 1.000.000.000,00. Use vírgula para centavos."
        }
        guard let rate = parsedAnnualRate, (0...100).contains(rate) else {
            return "Informe uma taxa anual entre 0% e 100%. Use vírgula para decimais."
        }
        guard periodInMonths != nil else {
            return periodType == .years
                ? "Informe um período inteiro de 1 a 50 anos."
                : "Informe um período inteiro de 1 a 600 meses."
        }
        return nil
    }

    public var isValid: Bool { inputValidationMessage == nil }

    public func calculateSimulation() {
        result = nil
        validationError = inputValidationMessage
        guard validationError == nil,
              let initial = parsedInitialAmount,
              let monthly = parsedMonthlyContribution,
              let rate = parsedAnnualRate,
              let months = periodInMonths else { return }
        let calculated = calculator.calculate(input: InvestmentInput(
            initialAmount: initial,
            monthlyContribution: monthly,
            annualInterestRate: rate,
            periodInMonths: months
        ))
        guard calculated.totalAmount.isFinite, calculated.breakdown.count == months else {
            validationError = "Não foi possível calcular esses valores. Revise os parâmetros."
            return
        }
        result = calculated
    }

    public func resetForm() {
        initialAmountString = "1000"
        monthlyContributionString = "200"
        annualRateString = "12"
        periodValueString = "5"
        periodType = .years
        result = nil
        validationError = nil
    }

    private func invalidateResult() {
        result = nil
        validationError = nil
    }

    public var numberInputHelp: String {
        "Padrão brasileiro: 1.234,56. Aceita ponto decimal (12.5); grupos de três dígitos usam milhares (1.234 = 1234). Para decimais ambíguos, use vírgula."
    }

    /// Prioritizes pt-BR grouping, then accepts a single decimal point for
    /// keyboards in other locales. Rejects malformed groups and partial parses.
    private static func parseBrazilianNumber(_ value: String) -> Double? {
        let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = "^(?:[0-9]+|[0-9]{1,3}(?:\\.[0-9]{3})+)(?:,[0-9]+)?$"
        let normalized: String
        if text.range(of: pattern, options: .regularExpression) != nil {
            normalized = text.replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: ".")
        } else if text.range(of: "^[0-9]+\\.[0-9]+$", options: .regularExpression) != nil {
            normalized = text
        } else {
            return nil
        }
        guard let number = Double(normalized), number.isFinite else { return nil }
        return number
    }
}
