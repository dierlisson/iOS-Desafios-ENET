import SwiftUI

@main
struct RickAndMortyCharactersApp: App {
    @State private var viewModel = CharactersViewModel()
    
    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: viewModel)
        }
    }
}
