import Foundation
import SwiftData

@Model
public final class FinancialTransaction: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var amount: Double
    public var rawType: String
    public var rawCategory: String
    public var date: Date
    public var notes: String
    
    public init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        type: TransactionType,
        category: TransactionCategory,
        date: Date = Date(),
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.rawType = type.rawValue
        self.rawCategory = category.rawValue
        self.date = date
        self.notes = notes
    }
    
    public var type: TransactionType {
        get { TransactionType(rawValue: rawType) ?? .expense }
        set { rawType = newValue.rawValue }
    }
    
    public var category: TransactionCategory {
        get { TransactionCategory(rawValue: rawCategory) ?? .outros }
        set { rawCategory = newValue.rawValue }
    }
    
    public static func sampleTransactions(for targetDate: Date = Date()) -> [FinancialTransaction] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: targetDate)
        components.day = 15
        let baseDate = calendar.date(from: components) ?? targetDate
        
        return [
            FinancialTransaction(
                title: "Salário Mensal",
                amount: 8500.00,
                type: .income,
                category: .salary,
                date: calendar.date(byAdding: .day, value: -10, to: baseDate) ?? baseDate,
                notes: "Pagamento de Salário"
            ),
            FinancialTransaction(
                title: "Projeto Freelance",
                amount: 2400.00,
                type: .income,
                category: .freelance,
                date: calendar.date(byAdding: .day, value: -5, to: baseDate) ?? baseDate,
                notes: "App iOS em Swift"
            ),
            FinancialTransaction(
                title: "Assinaturas & Lazer",
                amount: 120.00,
                type: .expense,
                category: .leisure,
                date: calendar.date(byAdding: .day, value: -3, to: baseDate) ?? baseDate,
                notes: "Streaming"
            ),
            FinancialTransaction(
                title: "Combustível",
                amount: 280.00,
                type: .expense,
                category: .transport,
                date: calendar.date(byAdding: .day, value: -2, to: baseDate) ?? baseDate,
                notes: "Posto Shell"
            ),
            FinancialTransaction(
                title: "Supermercado Extra",
                amount: 1250.00,
                type: .expense,
                category: .food,
                date: calendar.date(byAdding: .day, value: -1, to: baseDate) ?? baseDate,
                notes: "Compras mensais"
            )
        ]
    }
}
