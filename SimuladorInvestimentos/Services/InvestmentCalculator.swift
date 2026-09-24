import Foundation

/// Projeção com taxa anual efetiva constante e aportes no fim de cada mês.
/// Não inclui impostos, tarifas ou inflação.
public struct InvestmentCalculator {
    public init() {}

    /// Entradas inválidas retornam um resultado vazio, preservando o contrato
    /// público original. A interface apresenta os erros antes de chamar o motor.
    public func calculate(input: InvestmentInput) -> InvestmentResult {
        guard input.initialAmount.isFinite,
              input.monthlyContribution.isFinite,
              input.annualInterestRate.isFinite,
              (0...1_000_000_000).contains(input.initialAmount),
              (0...1_000_000_000).contains(input.monthlyContribution),
              (0...100).contains(input.annualInterestRate),
              (1...600).contains(input.periodInMonths) else {
            return emptyResult
        }

        // log1p/expm1 preservam precisão também em taxas muito pequenas.
        let monthlyRate = expm1(log1p(input.annualInterestRate / 100) / 12)
        var balance = input.initialAmount
        var deposits = input.initialAmount
        var breakdown: [MonthlyBreakdown] = []
        breakdown.reserveCapacity(input.periodInMonths)

        for month in 1...input.periodInMonths {
            let interest = balance * monthlyRate
            balance += interest + input.monthlyContribution
            deposits += input.monthlyContribution
            guard balance.isFinite, deposits.isFinite else { return emptyResult }
            breakdown.append(MonthlyBreakdown(
                month: month,
                deposited: deposits,
                interestEarned: interest,
                totalInterest: max(0, balance - deposits),
                totalBalance: balance
            ))
        }
        return InvestmentResult(
            totalAmount: balance,
            totalInvested: deposits,
            totalProfit: max(0, balance - deposits),
            breakdown: breakdown
        )
    }

    private var emptyResult: InvestmentResult {
        InvestmentResult(totalAmount: 0, totalInvested: 0, totalProfit: 0, breakdown: [])
    }
}
