import SwiftUI

@main
struct SimuladorInvestimentosApp: App {
    @State private var viewModel = SimulationViewModel()

    private var initialScreen: String {
        if CommandLine.arguments.contains("-SCREEN_FORM") {
            return "form"
        } else if CommandLine.arguments.contains("-SCREEN_RESULT") {
            return "result"
        } else {
            return "welcome"
        }
    }

    var body: some Scene {
        WindowGroup {
            switch initialScreen {
            case "form":
                NavigationStack {
                    SimulationFormView(viewModel: viewModel)
                }
            case "result":
                ResultPreviewContainer(viewModel: viewModel)
            default:
                WelcomeView()
            }
        }
    }
}

private struct ResultPreviewContainer: View {
    @Bindable var viewModel: SimulationViewModel

    init(viewModel: SimulationViewModel) {
        self.viewModel = viewModel
        viewModel.initialAmountString = "1000"
        viewModel.monthlyContributionString = "200"
        viewModel.annualRateString = "12"
        viewModel.periodValueString = "1"
        viewModel.periodType = .years
        viewModel.calculateSimulation()
    }

    var body: some View {
        NavigationStack {
            if let result = viewModel.result {
                SimulationResultView(result: result, viewModel: viewModel)
            } else {
                WelcomeView()
            }
        }
    }
}


