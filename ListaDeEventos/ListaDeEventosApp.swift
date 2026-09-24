import SwiftUI

@main
struct ListaDeEventosApp: App {
    @State private var viewModel = EventsViewModel()
    
    var body: some Scene {
        WindowGroup {
            EventListView(viewModel: viewModel)
        }
    }
}
