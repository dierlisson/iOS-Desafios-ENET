import SwiftUI

public struct SimulationResultView: View {
    let result: InvestmentResult
    private let viewModel: SimulationViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var showMonths = false

    public init(result: InvestmentResult, viewModel: SimulationViewModel) {
        self.result = result
        self.viewModel = viewModel
    }

    private var annualSummary: [MonthlyBreakdown] {
        result.breakdown.filter { $0.month.isMultiple(of: 12) || $0.month == result.breakdown.last?.month }
    }

    private var periodDescription: String {
        let months = result.breakdown.count
        if viewModel.periodType == .years && months % 12 == 0 {
            let years = months / 12
            return years == 1 ? "após 1 ano de investimento" : "após \(years) anos de investimento"
        } else if months % 12 == 0 {
            let years = months / 12
            return years == 1 ? "após 1 ano (\(months) meses) de investimento" : "após \(years) anos (\(months) meses) de investimento"
        } else {
            return months == 1 ? "após 1 mês de investimento" : "após \(months) meses de investimento"
        }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.title).foregroundStyle(Color.investmentTextGreen)
                        .accessibilityHidden(true)
                    Text("Valor final acumulado").foregroundStyle(.secondary)
                    Text(CurrencyFormatter.formatCurrency(result.totalAmount))
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    Text(periodDescription)
                        .font(.subheadline).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .investmentCard()
                let layout = dynamicTypeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(spacing: 14)) : AnyLayout(HStackLayout(alignment: .top, spacing: 14))
                layout {
                    metric("Total investido", value: result.totalInvested, icon: "banknote.fill", color: .blue)
                    metric("Lucro obtido", value: result.totalProfit, icon: "chart.line.uptrend.xyaxis", color: .investmentTextGreen)
                }
                VStack(alignment: .leading, spacing: 16) {
                    Label("Resumo por Ano", systemImage: "list.bullet.rectangle")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    ForEach(annualSummary) { item in
                        let partial = !item.month.isMultiple(of: 12)
                        summaryRow(title: "Ano \((item.month + 11) / 12)\(partial ? " · até o mês \(item.month)" : "")", item: item)
                        if item.id != annualSummary.last?.id { Divider() }
                    }
                }
                .investmentCard()
                DisclosureGroup("Evolução mês a mês", isExpanded: $showMonths) {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(result.breakdown) { item in
                            summaryRow(title: "Mês \(item.month)", item: item)
                            if item.id != result.breakdown.last?.id { Divider() }
                        }
                    }
                    .padding(.top, 16)
                }
                .font(.headline)
                .investmentCard()
                Button {
                    viewModel.resetForm()
                    dismiss()
                } label: {
                    Label("Nova simulação", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(InvestmentButtonStyle())
                Text("Valores estimados, sem desconto de impostos, taxas ou inflação.")
                    .font(.footnote).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 620)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .background(Color.investmentBackground)
        .navigationTitle("Resultado da Simulação")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func metric(_ title: String, value: Double, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon).renderingMode(.template).font(.title3).foregroundStyle(color)
                .padding(12).background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                .accessibilityHidden(true)
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Text(CurrencyFormatter.formatCurrency(value))
                .font(.title3.bold()).foregroundStyle(color)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .investmentCard()
    }

    private func summaryRow(title: String, item: MonthlyBreakdown) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(title).font(.subheadline)
                    Spacer(minLength: 16)
                    Text(CurrencyFormatter.formatCurrency(item.totalBalance)).font(.subheadline.bold())
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(.subheadline)
                    Text(CurrencyFormatter.formatCurrency(item.totalBalance)).font(.subheadline.bold())
                }
            }
            Text("Investido: \(CurrencyFormatter.formatCurrency(item.deposited))")
                .font(.caption).foregroundStyle(.secondary)
            Text("Juros acumulados: \(CurrencyFormatter.formatCurrency(item.totalInterest))")
                .font(.caption).foregroundStyle(Color.investmentTextGreen)
        }
        .accessibilityElement(children: .combine)
    }
}
