import XCTest
@testable import Pokedex

final class PokedexViewModelTests: XCTestCase {
    
    @MainActor
    func test_loadInitialPokemons_success_populatesPokemons() async {
        let mockService = MockPokedexService()
        let vm = PokedexViewModel(service: mockService)
        
        XCTAssertTrue(vm.pokemons.isEmpty)
        XCTAssertFalse(vm.isLoading)
        
        await vm.loadInitialPokemons()
        
        XCTAssertFalse(vm.pokemons.isEmpty)
        XCTAssertEqual(vm.pokemons.count, 4)
        XCTAssertNil(vm.errorMessage)
    }
    
    @MainActor
    func test_loadInitialPokemons_failure_setsErrorMessage() async {
        let mockService = MockPokedexService(shouldFail: true)
        let vm = PokedexViewModel(service: mockService)
        
        await vm.loadInitialPokemons()
        
        XCTAssertTrue(vm.pokemons.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
    }
    
    @MainActor
    func test_filterBySearchText_matchingNameOrID_returnsFilteredResults() async {
        let mockService = MockPokedexService()
        let vm = PokedexViewModel(service: mockService)
        await vm.loadInitialPokemons()
        
        vm.searchText = "chari"
        XCTAssertEqual(vm.filteredPokemons.count, 0)
        
        vm.searchText = "char"
        XCTAssertEqual(vm.filteredPokemons.count, 1)
        XCTAssertEqual(vm.filteredPokemons.first?.name, "charmander")
        
        vm.searchText = "25"
        XCTAssertEqual(vm.filteredPokemons.count, 1)
        XCTAssertEqual(vm.filteredPokemons.first?.name, "pikachu")
    }
    
    @MainActor
    func test_filterByType_returnsMatchingPokemons() async {
        let mockService = MockPokedexService()
        let vm = PokedexViewModel(service: mockService)
        await vm.loadInitialPokemons()
        
        vm.selectTypeFilter(.fire)
        XCTAssertEqual(vm.filteredPokemons.count, 1)
        XCTAssertEqual(vm.filteredPokemons.first?.name, "charmander")
        
        vm.selectTypeFilter(.electric)
        XCTAssertEqual(vm.filteredPokemons.count, 1)
        XCTAssertEqual(vm.filteredPokemons.first?.name, "pikachu")
        
        vm.clearFilters()
        XCTAssertEqual(vm.filteredPokemons.count, 4)
    }
    
    @MainActor
    func test_fetchDetail_populatesSelectedPokemonDetail() async {
        let mockService = MockPokedexService()
        let vm = PokedexViewModel(service: mockService)
        
        XCTAssertNil(vm.selectedPokemonDetail)
        await vm.fetchDetail(for: MockPokedexData.pikachu)
        
        XCTAssertNotNil(vm.selectedPokemonDetail)
        XCTAssertEqual(vm.selectedPokemonDetail?.pokemon.name, "pikachu")
        XCTAssertEqual(vm.selectedPokemonDetail?.stats.count, 6)
    }
}
