import SwiftUI

public struct SimulationFormView: View {
    @Bindable var viewModel: SimulationViewModel
    @State private var navigateToResult: Bool = false

    public init(viewModel: SimulationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Form {
            Section {
                HStack {
                    Label("Valor Inicial", systemImage: "dollarsign.circle")
                        .foregroundColor(.blue)
                    Spacer()
                    TextField("Ex: 1000", text: $viewModel.initialAmountString)
                        .decimalPadKeyboard()
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Label("Aporte Mensal", systemImage: "calendar.badge.plus")
                        .foregroundColor(.green)
                    Spacer()
                    TextField("Ex: 200", text: $viewModel.monthlyContributionString)
                        .decimalPadKeyboard()
                        .multilineTextAlignment(.trailing)
                }
            } header: {
                Text("Valores do Investimento")
            } footer: {
                Text("O valor inicial é depositado imediatamente e os aportes são adicionados a cada mês.")
            }

            Section {
                HStack {
                    Label("Taxa Anual (%)", systemImage: "percent")
                        .foregroundColor(.orange)
                    Spacer()
                    TextField("Ex: 12.0", text: $viewModel.annualRateString)
                        .decimalPadKeyboard()
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Label("Período", systemImage: "clock")
                        .foregroundColor(.purple)
                    Spacer()
                    TextField("Ex: 5", text: $viewModel.periodValueString)
                        .numberPadKeyboard()
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)

                    Picker("Tipo", selection: $viewModel.periodType) {
                        ForEach(PeriodType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 130)
                }
            } header: {
                Text("Rentabilidade e Tempo")
            } footer: {
                Text("Taxa de juros anual estimada para o cálculo composto.")
            }

            if let error = viewModel.validationError {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button(action: handleCalculation) {
                    HStack {
                        Spacer()
                        Text("Calcular Resultado")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "calculator")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .background(viewModel.isValid ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(12)
                }
                .disabled(!viewModel.isValid)
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle("Parâmetros")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button("Redefinir") {
                    viewModel.resetForm()
                }
                .foregroundColor(.red)
            }
            #else
            ToolbarItem(placement: .primaryAction) {
                Button("Redefinir") {
                    viewModel.resetForm()
                }
                .foregroundColor(.red)
            }
            #endif
        }
        .navigationDestination(isPresented: $navigateToResult) {
            if let result = viewModel.result {
                SimulationResultView(result: result, viewModel: viewModel)
            }
        }
    }

    private func handleCalculation() {
        viewModel.calculateSimulation()
        if viewModel.result != nil {
            navigateToResult = true
        }
    }
}

#Preview {
    NavigationStack {
        SimulationFormView(viewModel: SimulationViewModel())
    }
}
