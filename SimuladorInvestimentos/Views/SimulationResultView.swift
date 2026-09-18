import SwiftUI

public struct SimulationResultView: View {
    let result: InvestmentResult
    @ObservedObject private var legacyViewModelWrapper: LegacyWrapper
    private let viewModel: SimulationViewModel

    public init(result: InvestmentResult, viewModel: SimulationViewModel) {
        self.result = result
        self.viewModel = viewModel
        self.legacyViewModelWrapper = LegacyWrapper(viewModel: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Card Principal: Montante Final
                VStack(spacing: 8) {
                    Text("MONTANTE FINAL ESTIMADO")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.secondary)

                    Text(CurrencyFormatter.formatCurrency(result.totalAmount))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)

                    Text("em \(result.breakdown.count) meses (\(String(format: "%.1f", Double(result.breakdown.count)/12.0)) anos)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.customSecondarySystemGroupedBackground)
                        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                )

                // Grid de Cards Secundários
                HStack(spacing: 16) {
                    MetricCard(
                        title: "Total Investido",
                        value: CurrencyFormatter.formatCurrency(result.totalInvested),
                        icon: "wallet.pass.fill",
                        color: .indigo
                    )

                    MetricCard(
                        title: "Lucro em Juros",
                        value: CurrencyFormatter.formatCurrency(result.totalProfit),
                        icon: "arrow.up.right.circle.fill",
                        color: .green
                    )
                }

                // Barra Proporcional de Composição
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Composição do Patrimônio")
                            .font(.headline)
                        Spacer()
                        if result.totalAmount > 0 {
                            Text("\(Int((result.totalProfit / result.totalAmount) * 100))% Juros")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }

                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            let investedRatio = result.totalAmount > 0 ? result.totalInvested / result.totalAmount : 1.0
                            let profitRatio = result.totalAmount > 0 ? result.totalProfit / result.totalAmount : 0.0

                            Rectangle()
                                .fill(Color.indigo)
                                .frame(width: geometry.size.width * CGFloat(investedRatio))

                            Rectangle()
                                .fill(Color.green)
                                .frame(width: geometry.size.width * CGFloat(profitRatio))
                        }
                        .cornerRadius(8)
                    }
                    .frame(height: 16)

                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(Color.indigo).frame(width: 10, height: 10)
                            Text("Investido (\(CurrencyFormatter.formatCurrency(result.totalInvested)))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        HStack(spacing: 6) {
                            Circle().fill(Color.green).frame(width: 10, height: 10)
                            Text("Juros (\(CurrencyFormatter.formatCurrency(result.totalProfit)))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.customSecondarySystemGroupedBackground)
                )

                // Lista Detalhada Mês a Mês
                VStack(alignment: .leading, spacing: 12) {
                    Text("Evolução Mês a Mês")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal, 4)

                    LazyVStack(spacing: 10) {
                        ForEach(result.breakdown.prefix(24)) { item in
                            HStack {
                                Text("Mês \(item.month)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 60, alignment: .leading)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("+ \(CurrencyFormatter.formatCurrency(item.interestEarned)) juros")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    Text("Acumulado: \(CurrencyFormatter.formatCurrency(item.deposited))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(CurrencyFormatter.formatCurrency(item.totalBalance))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            .padding(12)
                            .background(Color.customSecondarySystemGroupedBackground)
                            .cornerRadius(12)
                        }

                        if result.breakdown.count > 24 {
                            Text("E mais \(result.breakdown.count - 24) meses de evolução...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.customSystemGroupedBackground.ignoresSafeArea())
        .navigationTitle("Resultado da Simulação")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.headline)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.customSecondarySystemGroupedBackground)
        )
    }
}

private class LegacyWrapper: ObservableObject {
    let viewModel: SimulationViewModel
    init(viewModel: SimulationViewModel) {
        self.viewModel = viewModel
    }
}
