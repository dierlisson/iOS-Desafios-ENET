import SwiftUI

public struct WelcomeView: View {
    @State private var viewModel = SimulationViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 96, height: 96)
                        .background(Color.investmentGreen.gradient, in: RoundedRectangle(cornerRadius: 26))
                        .accessibilityHidden(true)
                        .padding(.top, 24)

                    VStack(spacing: 14) {
                        Text("Simulador de\nInvestimentos")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                        Text("Descubra quanto seus investimentos podem render com aportes mensais e juros compostos.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)

                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "function")
                            .font(.title2)
                            .foregroundStyle(Color.investmentTextGreen)
                            .padding(12)
                            .background(Color.investmentGreen.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Simulação Inteligente").font(.headline)
                            Text("Calcule projeções precisas com juros compostos.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .investmentCard()

                    VStack(spacing: 16) {
                        Text("Pronto para começar?").font(.title3.bold())
                        Text("Configure sua simulação e descubra o potencial dos seus investimentos.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        NavigationLink {
                            SimulationFormView(viewModel: viewModel)
                        } label: {
                            Label("Começar simulação", systemImage: "arrow.right")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(InvestmentButtonStyle())
                    }
                    .investmentCard()
                    Text("Uma projeção para ajudar no seu planejamento.")
                        .font(.footnote).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 620)
                .padding(24)
                .frame(maxWidth: .infinity)
            }
            .background(Color.investmentBackground)
            .navigationTitle("")
        }
        .tint(.investmentTextGreen)
    }
}

struct InvestmentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 17)
            .background(Color.investmentGreen.opacity(configuration.isPressed ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 14))
    }
}

extension View {
    func investmentCard() -> some View {
        self.padding(20)
            .frame(maxWidth: .infinity)
            .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.primary.opacity(0.04)))
    }
}

#Preview { WelcomeView() }
