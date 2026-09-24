import XCTest
import SwiftData
@testable import ControleFinanceiro

final class ControleFinanceiroTests: XCTestCase {
    
    func testTransactionCreation() {
        let transaction = FinancialTransaction(
            title: "Supermercado",
            amount: 250.75,
            type: .expense,
            category: .food,
            notes: "Compras do mês"
        )
        
        XCTAssertEqual(transaction.title, "Supermercado")
        XCTAssertEqual(transaction.amount, 250.75)
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertEqual(transaction.category, .food)
        XCTAssertEqual(transaction.notes, "Compras do mês")
    }
    
    @MainActor
    func testSwiftDataContainerPersistence() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FinancialTransaction.self, configurations: config)
        let context = container.mainContext
        
        let income = FinancialTransaction(
            title: "Salário",
            amount: 5000.0,
            type: .income,
            category: .salary
        )
        
        let expense = FinancialTransaction(
            title: "Aluguel",
            amount: 1500.0,
            type: .expense,
            category: .housing
        )
        
        context.insert(income)
        context.insert(expense)
        
        let fetchDescriptor = FetchDescriptor<FinancialTransaction>()
        let results = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(results.count, 2)
        
        let totalIncome = results.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let totalExpense = results.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        let netBalance = totalIncome - totalExpense
        
        XCTAssertEqual(totalIncome, 5000.0)
        XCTAssertEqual(totalExpense, 1500.0)
        XCTAssertEqual(netBalance, 3500.0)
    }
}
