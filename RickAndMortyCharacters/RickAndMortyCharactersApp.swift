import SwiftUI

@main
struct RickAndMortyCharactersApp: App {
    @State private var viewModel = CharactersViewModel()
    @State private var initialDetailCharacter: RMCharacter? = nil
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let character = initialDetailCharacter {
                    NavigationStack {
                        CharacterDetailView(character: character, favoritesManager: viewModel.favoritesManager)
                    }
                } else {
                    CharacterListView(viewModel: viewModel)
                }
            }
            .task {
                if CommandLine.arguments.contains("--show-detail") {
                    initialDetailCharacter = RMCharacter(
                        id: 1,
                        name: "Rick Sanchez",
                        status: .alive,
                        species: "Human",
                        type: "Genius Scientist",
                        gender: .male,
                        origin: RMLocationRef(name: "Earth (C-137)", url: ""),
                        location: RMLocationRef(name: "Citadel of Ricks", url: ""),
                        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                        episode: ["ep1", "ep2", "ep3", "ep4", "ep5"],
                        url: "",
                        created: ""
                    )
                } else if CommandLine.arguments.contains("--show-favorites") {
                    viewModel.favoritesManager.toggleFavorite(1)
                    viewModel.favoritesManager.toggleFavorite(2)
                    viewModel.showOnlyFavorites = true
                } else if CommandLine.arguments.contains("--filter-alive") {
                    viewModel.selectedStatus = .alive
                    viewModel.selectedGender = .male
                }
            }
        }
    }
}
