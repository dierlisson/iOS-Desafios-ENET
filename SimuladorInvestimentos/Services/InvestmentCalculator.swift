import Foundation

/// Motor de cálculo responsável pela simulação de juros compostos.
public struct InvestmentCalculator {
    
    public init() {}

    /// Realiza a simulação baseada nos parâmetros de entrada.
    /// - Parameter input: Dados de entrada contendo valor inicial, aporte mensal, taxa anual e período.
    /// - Returns: Estrutura `InvestmentResult` contendo o montante final, total investido, lucro e extrato mês a mês.
    public func calculate(input: InvestmentInput) -> InvestmentResult {
        guard input.periodInMonths > 0 else {
            return InvestmentResult(totalAmount: 0, totalInvested: 0, totalProfit: 0, breakdown: [])
        }

        // Taxa mensal equivalente a partir da taxa anual (Taxa equivalente composta)
        let monthlyRate = pow(1.0 + (input.annualInterestRate / 100.0), 1.0 / 12.0) - 1.0

        var currentBalance = max(0, input.initialAmount)
        var totalDeposited = max(0, input.initialAmount)
        var totalInterestEarned: Double = 0.0
        var breakdownList: [MonthlyBreakdown] = []

        for month in 1...input.periodInMonths {
            let interestForMonth = currentBalance * monthlyRate
            totalInterestEarned += interestForMonth
            currentBalance += interestForMonth + max(0, input.monthlyContribution)
            totalDeposited += max(0, input.monthlyContribution)

            let entry = MonthlyBreakdown(
                month: month,
                deposited: totalDeposited,
                interestEarned: interestForMonth,
                totalInterest: totalInterestEarned,
                totalBalance: currentBalance
            )
            breakdownList.append(entry)
        }

        let profit = currentBalance - totalDeposited

        return InvestmentResult(
            totalAmount: currentBalance,
            totalInvested: totalDeposited,
            totalProfit: max(0, profit),
            breakdown: breakdownList
        )
    }
}
