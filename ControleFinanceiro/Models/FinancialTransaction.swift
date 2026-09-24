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
}
