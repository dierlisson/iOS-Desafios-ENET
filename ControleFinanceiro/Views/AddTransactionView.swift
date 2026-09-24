import SwiftUI
import SwiftData

public struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var amountString: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: TransactionCategory = .food
    @State private var date: Date = Date()
    @State private var notes: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Lançamento") {
                    Picker("Tipo", selection: $type) {
                        ForEach(TransactionType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: type) { _, newType in
                        if category.defaultType != newType {
                            if newType == .income {
                                category = .salary
                            } else {
                                category = .food
                            }
                        }
                    }
                }
                
                Section("Informações Básicas") {
                    TextField("Título (ex: Mercado, Salário)", text: $title)
                    
                    TextField("Valor (R$)", text: $amountString)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    
                    Picker("Categoria", selection: $category) {
                        ForEach(TransactionCategory.allCases) { c in
                            HStack {
                                Image(systemName: c.iconName)
                                    .foregroundStyle(c.color)
                                Text(c.rawValue)
                            }
                            .tag(c)
                        }
                    }
                }
                
                Section("Data e Notas") {
                    DatePicker("Data", selection: $date, displayedComponents: .date)
                    TextField("Observações (opcional)", text: $notes)
                }
            }
            .navigationTitle("Novo Lançamento")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveTransaction()
                    }
                    .bold()
                }
            }
            .alert("Atenção", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveTransaction() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty else {
            alertMessage = "Por favor, informe um título para o lançamento."
            showAlert = true
            return
        }
        
        let cleanedAmount = amountString.replacingOccurrences(of: ",", with: ".")
        guard let parsedAmount = Double(cleanedAmount), parsedAmount > 0, parsedAmount.isFinite else {
            alertMessage = "Por favor, informe um valor válido maior que zero."
            showAlert = true
            return
        }
        
        let newTransaction = FinancialTransaction(
            title: cleanTitle,
            amount: parsedAmount,
            type: type,
            category: category,
            date: date,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        modelContext.insert(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView()
}
