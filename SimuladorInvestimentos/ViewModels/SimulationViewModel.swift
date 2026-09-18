import Foundation
import Combine

public enum PeriodType: String, CaseIterable, Identifiable {
    case years = "Anos"
    case months = "Meses"

    public var id: String { rawValue }
}

@Observable
public final class SimulationViewModel {
    // MARK: - Input State
    public var initialAmountString: String = "1000"
    public var monthlyContributionString: String = "200"
    public var annualRateString: String = "12"
    public var periodValueString: String = "5"
    public var periodType: PeriodType = .years

    // MARK: - Output State
    public var result: InvestmentResult? = nil
    public var validationError: String? = nil

    private let calculator: InvestmentCalculator

    public init(calculator: InvestmentCalculator = InvestmentCalculator()) {
        self.calculator = calculator
    }

    // MARK: - Derived Properties

    public var parsedInitialAmount: Double? {
        Double(initialAmountString.replacingOccurrences(of: ",", with: "."))
    }

    public var parsedMonthlyContribution: Double? {
        Double(monthlyContributionString.replacingOccurrences(of: ",", with: "."))
    }

    public var parsedAnnualRate: Double? {
        Double(annualRateString.replacingOccurrences(of: ",", with: "."))
    }

    public var parsedPeriodValue: Int? {
        Int(periodValueString)
    }

    public var periodInMonths: Int? {
        guard let value = parsedPeriodValue, value > 0 else { return nil }
        switch periodType {
        case .years:
            return value * 12
        case .months:
            return value
        }
    }

    public var isValid: Bool {
        guard let initial = parsedInitialAmount, initial >= 0,
              let monthly = parsedMonthlyContribution, monthly >= 0,
              let rate = parsedAnnualRate, rate >= 0,
              let months = periodInMonths, months > 0, months <= 600 else {
            return false
        }
        return true
    }

    // MARK: - Actions

    public func calculateSimulation() {
        validationError = nil

        guard let initial = parsedInitialAmount, initial >= 0 else {
            validationError = "Por favor, insira um valor inicial válido (ex: 1000)."
            return
        }

        guard let monthly = parsedMonthlyContribution, monthly >= 0 else {
            validationError = "Por favor, insira um aporte mensal válido (ex: 200)."
            return
        }

        guard let rate = parsedAnnualRate, rate >= 0 else {
            validationError = "Por favor, insira uma taxa de juros anual válida (ex: 12)."
            return
        }

        guard let months = periodInMonths, months > 0 else {
            validationError = "Por favor, insira um período válido maior que zero."
            return
        }

        if months > 600 {
            validationError = "O período máximo permitido é de 50 anos (600 meses)."
            return
        }

        let input = InvestmentInput(
            initialAmount: initial,
            monthlyContribution: monthly,
            annualInterestRate: rate,
            periodInMonths: months
        )

        self.result = calculator.calculate(input: input)
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
}
