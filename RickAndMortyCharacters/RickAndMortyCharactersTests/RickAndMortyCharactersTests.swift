import XCTest
@testable import RickAndMortyCharacters

final class MockRickAndMortyService: RickAndMortyServiceProtocol {
    var shouldFail: Bool = false
    
    func fetchCharacters(name: String?, status: RMStatus?, gender: RMGender?, page: Int) async throws -> (characters: [RMCharacter], hasNextPage: Bool) {
        if shouldFail {
            throw NetworkError.noConnection
        }
        
        let sample = RMCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: RMLocationRef(name: "Earth (C-137)", url: ""),
            location: RMLocationRef(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: ["ep1", "ep2"],
            url: "",
            created: ""
        )
        
        if let name = name, !name.isEmpty, !sample.name.localizedCaseInsensitiveContains(name) {
            return (characters: [], hasNextPage: false)
        }
        
        if let status = status, status != sample.status {
            return (characters: [], hasNextPage: false)
        }
        
        if let gender = gender, gender != sample.gender {
            return (characters: [], hasNextPage: false)
        }
        
        return (characters: [sample], hasNextPage: false)
    }
}

final class RickAndMortyCharactersTests: XCTestCase {
    
    @MainActor
    func testSuccessfulFetch() async {
        let mockService = MockRickAndMortyService()
        let viewModel = CharactersViewModel(service: mockService)
        
        await viewModel.resetAndLoad()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez")
    }
    
    @MainActor
    func testGenderFilterMatching() async {
        let mockService = MockRickAndMortyService()
        let viewModel = CharactersViewModel(service: mockService)
        viewModel.selectedGender = .male
        
        await viewModel.resetAndLoad()
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.gender, .male)
    }
    
    @MainActor
    func testGenderFilterMismatchReturnsEmpty() async {
        let mockService = MockRickAndMortyService()
        let viewModel = CharactersViewModel(service: mockService)
        viewModel.selectedGender = .female
        
        await viewModel.resetAndLoad()
        
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
    
    @MainActor
    func testFavoritesToggle() {
        let favoritesManager = FavoritesManager()
        let characterId = 101
        
        XCTAssertFalse(favoritesManager.isFavorite(characterId))
        favoritesManager.toggleFavorite(characterId)
        XCTAssertTrue(favoritesManager.isFavorite(characterId))
        favoritesManager.toggleFavorite(characterId)
        XCTAssertFalse(favoritesManager.isFavorite(characterId))
    }
    
    @MainActor
    func testNetworkErrorHandling() async {
        let mockService = MockRickAndMortyService()
        mockService.shouldFail = true
        let viewModel = CharactersViewModel(service: mockService)
        
        await viewModel.resetAndLoad()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
}
