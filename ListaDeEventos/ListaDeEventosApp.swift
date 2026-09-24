import SwiftUI

@main
struct ListaDeEventosApp: App {
    @State private var viewModel: EventsViewModel
    
    init() {
        let args = ProcessInfo.processInfo.arguments
        var category: EventCategory = .all
        var search = ""
        
        if args.contains("--test-category-design") {
            category = .design
        } else if args.contains("--test-category-workshop") {
            category = .workshop
        } else if args.contains("--test-search") {
            search = "SwiftUI"
        }
        
        _viewModel = State(initialValue: EventsViewModel(initialCategory: category, initialSearchText: search))
    }
    
    var body: some Scene {
        WindowGroup {
            EventListView(viewModel: viewModel)
        }
    }
}
