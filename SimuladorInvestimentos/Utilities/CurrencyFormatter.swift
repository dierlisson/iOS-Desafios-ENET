import Foundation

public struct CurrencyFormatter {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    private static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    /// Formata um valor numérico para Moeda (ex: R$ 1.250,50)
    public static func formatCurrency(_ value: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: value)) ?? "R$ \(String(format: "%.2f", value))"
    }

    /// Formata um valor numérico para Porcentagem (ex: 10,5%)
    public static func formatPercent(_ value: Double) -> String {
        let formatted = percentFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.1f", value)
        return "\(formatted)%"
    }
}
