import SwiftUI
import SwiftData

@main
struct ControleFinanceiroApp: App {
    var body: some Scene {
        WindowGroup {
            FinanceDashboardView()
        }
        .modelContainer(for: FinancialTransaction.self)
    }
}
