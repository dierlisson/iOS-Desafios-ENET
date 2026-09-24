import SwiftUI

public struct SimulationFormView: View {
    @Bindable var viewModel: SimulationViewModel
    @State private var navigateToResult = false
    @State private var presentedResult: InvestmentResult?
    @FocusState private var focusedField: Field?
    private enum Field: Hashable { case initial, monthly, rate, period }

    public init(viewModel: SimulationViewModel) { self.viewModel = viewModel }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Configure sua simulação").font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                    Text("Preencha os dados para calcular sua projeção.")
                        .foregroundStyle(.secondary)
                }
                input("Valor inicial", icon: "dollarsign.circle", color: .investmentTextGreen,
                      text: $viewModel.initialAmountString, prefix: "R$", suffix: nil,
                      help: "Valor que você já possui para investir", field: .initial)
                input("Aporte mensal", icon: "calendar", color: .blue,
                      text: $viewModel.monthlyContributionString, prefix: "R$", suffix: nil,
                      help: "Valor depositado ao final de cada mês", field: .monthly)
                input("Taxa de juros (% ao ano)", icon: "percent", color: .orange,
                      text: $viewModel.annualRateString, prefix: nil, suffix: "%",
                      help: "Taxa anual esperada para o investimento", field: .rate)
                Text(viewModel.numberInputHelp)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 12) {
                    input("Tempo de investimento", icon: "clock.fill", color: .purple,
                          text: $viewModel.periodValueString, prefix: nil,
                          suffix: viewModel.periodType.rawValue.lowercased(),
                          help: "Período de até 50 anos (600 meses)", field: .period)
                    Picker("Unidade do período", selection: $viewModel.periodType) {
                        ForEach(PeriodType.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
                if let error = viewModel.validationError ?? viewModel.inputValidationMessage {
                    Label(error, systemImage: "exclamationmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("simulation.validationError")
                }
                Button {
                    focusedField = nil
                    viewModel.calculateSimulation()
                    if viewModel.validationError == nil, let result = viewModel.result {
                        presentedResult = result
                        navigateToResult = true
                    }
                } label: {
                    Label("Calcular resultado", systemImage: "chart.line.uptrend.xyaxis")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(InvestmentButtonStyle())
                Text("Projeção com taxa constante, sem desconto de impostos, taxas ou inflação. A rentabilidade real pode variar.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .frame(maxWidth: 620)
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.investmentBackground)
        .navigationTitle("Simulação")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Redefinir") { focusedField = nil; viewModel.resetForm() }
            }
            #if os(iOS)
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Concluir") { focusedField = nil }
            }
            #endif
        }
        .navigationDestination(isPresented: $navigateToResult) {
            if let result = presentedResult {
                SimulationResultView(result: result, viewModel: viewModel)
            }
        }
    }

    private func input(_ title: String, icon: String, color: Color, text: Binding<String>,
                       prefix: String?, suffix: String?, help: String, field: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label { Text(title).foregroundStyle(.primary) } icon: {
                Image(systemName: icon).foregroundStyle(color)
            }
            .font(.subheadline.weight(.semibold))
            HStack(spacing: 12) {
                if let prefix { Text(prefix).foregroundStyle(.secondary) }
                Group {
                    if field == .period {
                        TextField("5", text: text).numberPadKeyboard()
                    } else {
                        TextField("0,00", text: text).decimalPadKeyboard()
                    }
                }
                .focused($focusedField, equals: field)
                .accessibilityLabel(title)
                .accessibilityHint(help)
                .accessibilityIdentifier("simulation.\(field)")
                if let suffix { Text(suffix).foregroundStyle(.secondary) }
            }
            .padding(16)
            .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 13))
            .overlay(RoundedRectangle(cornerRadius: 13)
                .stroke(focusedField == field ? Color.investmentTextGreen : Color.primary.opacity(0.12), lineWidth: 1))
            Text(help).font(.caption).foregroundStyle(.secondary)
        }
    }
}
