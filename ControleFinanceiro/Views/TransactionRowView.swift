import SwiftUI

public struct TransactionRowView: View {
    public let transaction: FinancialTransaction
    
    public init(transaction: FinancialTransaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            Image(systemName: transaction.category.iconName)
                .font(.title3)
                .foregroundStyle(transaction.category.color)
                .frame(width: 44, height: 44)
                .background(transaction.category.color.opacity(0.12), in: Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                HStack(spacing: 6) {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if !transaction.notes.isEmpty {
                        Text("• \(transaction.notes)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Text("\(transaction.type == .income ? "+" : "-") \(CurrencyFormatter.format(transaction.amount))")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(transaction.type.color)
        }
        .padding(.vertical, 6)
    }
}
