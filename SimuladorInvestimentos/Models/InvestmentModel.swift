import Foundation

/// Parâmetros de entrada para o cálculo de investimentos.
public struct InvestmentInput: Equatable {
    public var initialAmount: Double
    public var monthlyContribution: Double
    public var annualInterestRate: Double
    public var periodInMonths: Int

    public init(
        initialAmount: Double = 1000.0,
        monthlyContribution: Double = 200.0,
        annualInterestRate: Double = 10.0,
        periodInMonths: Int = 12
    ) {
        self.initialAmount = initialAmount
        self.monthlyContribution = monthlyContribution
        self.annualInterestRate = annualInterestRate
        self.periodInMonths = periodInMonths
    }
}

/// Detalhamento mês a mês da evolução do investimento.
public struct MonthlyBreakdown: Identifiable, Equatable {
    public var id: Int { month }
    public let month: Int
    public let deposited: Double
    public let interestEarned: Double
    public let totalInterest: Double
    public let totalBalance: Double

    public init(
        month: Int,
        deposited: Double,
        interestEarned: Double,
        totalInterest: Double,
        totalBalance: Double
    ) {
        self.month = month
        self.deposited = deposited
        self.interestEarned = interestEarned
        self.totalInterest = totalInterest
        self.totalBalance = totalBalance
    }
}

/// Resultado consolidado da simulação de investimentos.
public struct InvestmentResult: Equatable {
    public let totalAmount: Double
    public let totalInvested: Double
    public let totalProfit: Double
    public let breakdown: [MonthlyBreakdown]

    public init(
        totalAmount: Double,
        totalInvested: Double,
        totalProfit: Double,
        breakdown: [MonthlyBreakdown]
    ) {
        self.totalAmount = totalAmount
        self.totalInvested = totalInvested
        self.totalProfit = totalProfit
        self.breakdown = breakdown
    }
}
