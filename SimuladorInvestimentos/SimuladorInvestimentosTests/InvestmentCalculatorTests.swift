import XCTest
@testable import SimuladorInvestimentos

final class InvestmentCalculatorTests: XCTestCase {
    private var calculator: InvestmentCalculator!

    override func setUp() {
        super.setUp()
        calculator = InvestmentCalculator()
    }

    override func tearDown() {
        calculator = nil
        super.tearDown()
    }

    func testCompoundInterestCalculation() {
        // Arrange
        let input = InvestmentInput(
            initialAmount: 1000.0,
            monthlyContribution: 100.0,
            annualInterestRate: 12.0,
            periodInMonths: 12
        )

        // Act
        let result = calculator.calculate(input: input)

        // Assert
        // Total investido: R$ 1.000 (inicial) + 12 * R$ 100 = R$ 2.200
        XCTAssertEqual(result.totalInvested, 2200.0, accuracy: 0.01)
        // O montante final deve ser maior que o investido devido aos juros
        XCTAssertGreaterThan(result.totalAmount, result.totalInvested)
        // O lucro em juros deve ser positivo
        XCTAssertGreaterThan(result.totalProfit, 0)
        // Deve haver exatamente 12 registros de meses
        XCTAssertEqual(result.breakdown.count, 12)
    }

    func testZeroMonthsReturnsZeroAmount() {
        let input = InvestmentInput(
            initialAmount: 1000.0,
            monthlyContribution: 100.0,
            annualInterestRate: 12.0,
            periodInMonths: 0
        )

        let result = calculator.calculate(input: input)

        XCTAssertEqual(result.totalAmount, 0)
        XCTAssertEqual(result.totalInvested, 0)
        XCTAssertTrue(result.breakdown.isEmpty)
    }

    func testCalculationWithZeroContribution() {
        let input = InvestmentInput(
            initialAmount: 1000.0,
            monthlyContribution: 0.0,
            annualInterestRate: 12.0,
            periodInMonths: 12
        )

        let result = calculator.calculate(input: input)

        XCTAssertEqual(result.totalInvested, 1000.0, accuracy: 0.01)
        // Montante esperado com 12% ao ano (taxa composta = 1000 * 1.12)
        XCTAssertEqual(result.totalAmount, 1120.0, accuracy: 0.5)
    }
}
