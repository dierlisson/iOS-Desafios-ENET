import SwiftUI

@main
struct TechEventsApp: App {
    @State private var viewModel: TechEventsViewModel
    
    init() {
        let localRepo = TechEventsLocalRepository()
        let remoteRepo = TechEventsRemoteRepository(localRepository: localRepo, simulatedDelayNanoseconds: 100_000_000)
        let fetchUseCase = FetchEventsUseCase(repository: remoteRepo)
        let vm = TechEventsViewModel(fetchEventsUseCase: fetchUseCase, repository: remoteRepo)
        _viewModel = State(wrappedValue: vm)
    }
    
    var body: some Scene {
        WindowGroup {
            TechEventsCatalogView(viewModel: viewModel)
        }
    }
}
