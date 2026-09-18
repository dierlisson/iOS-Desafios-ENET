import SwiftUI

public struct WelcomeView: View {
    @State private var viewModel = SimulationViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Ícone Principal / Hero
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.8), .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .indigo.opacity(0.3), radius: 12, x: 0, y: 6)

                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 54, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 8)

                // Títulos
                VStack(spacing: 12) {
                    Text("Simulador de Investimentos")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    Text("Descubra quanto seu dinheiro pode render com a força dos juros compostos.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                }

                // Cards de Destaque
                VStack(spacing: 16) {
                    FeatureRow(
                        icon: "dollarsign.circle.fill",
                        color: .green,
                        title: "Aportes Mensais",
                        subtitle: "Simule a adição de novos recursos todos os meses"
                    )

                    FeatureRow(
                        icon: "percent",
                        color: .orange,
                        title: "Juros Compostos",
                        subtitle: "Veja o efeito da rentabilidade acumulada ao longo do tempo"
                    )

                    FeatureRow(
                        icon: "list.bullet.rectangle.fill",
                        color: .blue,
                        title: "Relatório Detalhado",
                        subtitle: "Confira o resultado consolidado e a evolução mês a mês"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                // Botão de Iniciar
                NavigationLink(destination: SimulationFormView(viewModel: viewModel)) {
                    HStack {
                        Text("Começar Simulação")
                            .font(.headline)
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.blue, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .indigo.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .navigationTitle("")
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.customSecondarySystemGroupedBackground)
        .cornerRadius(14)
    }
}

#Preview {
    WelcomeView()
}
