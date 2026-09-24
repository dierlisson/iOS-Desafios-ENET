import SwiftUI
import SwiftData

public struct FinanceDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FinancialTransaction.date, order: .reverse) private var allTransactions: [FinancialTransaction]
    
    @State private var showingAddSheet: Bool = false
    @State private var selectedFilterCategory: String = "Todas"
    @State private var selectedMonthDate: Date = Date()
    
    public init() {}
    
    // Transações filtradas por mês/ano e categoria
    private var filteredTransactions: [FinancialTransaction] {
        let calendar = Calendar.current
        let targetMonth = calendar.component(.month, from: selectedMonthDate)
        let targetYear = calendar.component(.year, from: selectedMonthDate)
        
        return allTransactions.filter { item in
            let itemMonth = calendar.component(.month, from: item.date)
            let itemYear = calendar.component(.year, from: item.date)
            
            let matchesDate = (itemMonth == targetMonth && itemYear == targetYear)
            let matchesCategory = (selectedFilterCategory == "Todas") || (item.rawCategory == selectedFilterCategory)
            
            return matchesDate && matchesCategory
        }
    }
    
    private var monthIncome: Double {
        filteredTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    private var monthExpense: Double {
        filteredTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    private var monthBalance: Double {
        monthIncome - monthExpense
    }
    
    private var monthNameYear: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM 'de' yyyy"
        return formatter.string(from: selectedMonthDate).capitalized
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Selector de Mês
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                    
                    Text(monthNameYear)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3.bold())
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.customSystemBackground)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Summary Card (Saldo, Entradas, Saídas)
                        VStack(spacing: 16) {
                            VStack(spacing: 6) {
                                Text("Saldo do Mês")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Text(CurrencyFormatter.format(monthBalance))
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(monthBalance >= 0 ? Color.primary : Color.red)
                            }
                            
                            HStack(spacing: 16) {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.down.left.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.green)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Entradas").font(.caption).foregroundStyle(.secondary)
                                        Text(CurrencyFormatter.format(monthIncome))
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.green)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                                
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.up.right.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.red)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Saídas").font(.caption).foregroundStyle(.secondary)
                                        Text(CurrencyFormatter.format(monthExpense))
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.red)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(20)
                        .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 22))
                        
                        // Category Filter Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(title: "Todas", isSelected: selectedFilterCategory == "Todas") {
                                    selectedFilterCategory = "Todas"
                                }
                                ForEach(TransactionCategory.allCases) { cat in
                                    FilterChip(title: cat.rawValue, isSelected: selectedFilterCategory == cat.rawValue) {
                                        selectedFilterCategory = cat.rawValue
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        
                        // Transactions List / Empty State
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Lançamentos")
                                    .font(.headline)
                                Spacer()
                                Text("\(filteredTransactions.count) itens")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if filteredTransactions.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "tray.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
                                    Text("Nenhum lançamento cadastrado neste mês.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 32)
                                .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 16))
                            } else {
                                LazyVStack(spacing: 10) {
                                    ForEach(filteredTransactions) { transaction in
                                        TransactionRowView(transaction: transaction)
                                            .padding(12)
                                            .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 16))
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    deleteTransaction(transaction)
                                                } label: {
                                                    Label("Excluir", systemImage: "trash")
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
                .background(Color.customSystemGroupedBackground)
            }
            .navigationTitle("Controle Financeiro")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTransactionView()
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedMonthDate) {
            selectedMonthDate = newDate
        }
    }
    
    private func deleteTransaction(_ item: FinancialTransaction) {
        modelContext.delete(item)
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(isSelected ? .bold : .regular))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.primary.opacity(0.06), in: Capsule())
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FinanceDashboardView()
        .modelContainer(for: FinancialTransaction.self, inMemory: true)
}
