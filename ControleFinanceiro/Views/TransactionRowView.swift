import SwiftUI

public struct TransactionRowView: View {
    public let transaction: FinancialTransaction
    
    public init(transaction: FinancialTransaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            Image(systemName: transaction.category.iconName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(transaction.category.color)
                .frame(width: 48, height: 48)
                .background(transaction.category.color.opacity(0.14), in: Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if !transaction.notes.isEmpty {
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(transaction.notes)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Text("\(transaction.type == .income ? "+" : "-") \(CurrencyFormatter.format(transaction.amount))")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(transaction.type == .income ? Color(red: 0.1, green: 0.7, blue: 0.3) : Color(red: 0.9, green: 0.2, blue: 0.2))
        }
        .padding(.vertical, 4)
    }
}
