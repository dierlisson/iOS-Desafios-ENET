import Foundation
import Observation

@Observable
public final class PokedexViewModel {
    public var pokemons: [Pokemon] = []
    public var searchText: String = ""
    public var selectedType: PokemonType? = nil
    public var isLoading: Bool = false
    public var isLoadingMore: Bool = false
    public var errorMessage: String? = nil
    public var hasMorePages: Bool = true
    
    public var selectedPokemonDetail: PokemonDetail? = nil
    public var isLoadingDetail: Bool = false
    public var detailErrorMessage: String? = nil
    
    private let service: PokedexServiceProtocol
    private var offset: Int = 0
    private let limit: Int = 20
    
    public init(service: PokedexServiceProtocol = PokedexService()) {
        self.service = service
    }
    
    @MainActor
    public func loadInitialPokemons() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        offset = 0
        
        do {
            let result = try await service.fetchPokemonList(limit: limit, offset: offset)
            self.pokemons = result.items
            self.hasMorePages = result.hasMore
            self.offset += limit
        } catch {
            self.errorMessage = "Não foi possível carregar a Pokédex. Verifique a conexão com a internet."
        }
        
        isLoading = false
    }
    
    @MainActor
    public func loadNextPageIfNeeded(currentPokemon: Pokemon) async {
        guard hasMorePages, !isLoading, !isLoadingMore else { return }
        
        // Trigger load next page when approaching the last 3 items of loaded list
        guard let index = pokemons.firstIndex(where: { $0.id == currentPokemon.id }),
              index >= pokemons.count - 3 else {
            return
        }
        
        isLoadingMore = true
        
        do {
            let result = try await service.fetchPokemonList(limit: limit, offset: offset)
            
            // Append non-duplicate pokemons
            let existingIDs = Set(self.pokemons.map { $0.id })
            let newItems = result.items.filter { !existingIDs.contains($0.id) }
            
            self.pokemons.append(contentsOf: newItems)
            self.hasMorePages = result.hasMore
            self.offset += limit
        } catch {
            // Ignore pagination errors silently or retain current list
        }
        
        isLoadingMore = false
    }
    
    public var filteredPokemons: [Pokemon] {
        var result = pokemons
        
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmedQuery.isEmpty {
            result = result.filter { pokemon in
                pokemon.name.lowercased().contains(trimmedQuery) ||
                "\(pokemon.id)".contains(trimmedQuery) ||
                pokemon.formattedID.lowercased().contains(trimmedQuery)
            }
        }
        
        if let selectedType = selectedType {
            result = result.filter { pokemon in
                pokemon.types.contains(selectedType)
            }
        }
        
        return result
    }
    
    public func selectTypeFilter(_ type: PokemonType?) {
        if selectedType == type {
            selectedType = nil
        } else {
            selectedType = type
        }
    }
    
    public func clearFilters() {
        searchText = ""
        selectedType = nil
    }
    
    @MainActor
    public func fetchDetail(for pokemon: Pokemon) async {
        isLoadingDetail = true
        detailErrorMessage = nil
        selectedPokemonDetail = nil
        
        do {
            let detail = try await service.fetchPokemonDetail(nameOrID: "\(pokemon.id)")
            self.selectedPokemonDetail = detail
        } catch {
            // Fallback detail constructed from basic list item
            let fallbackStats = [
                PokemonStat(name: "hp", value: 50),
                PokemonStat(name: "attack", value: 50),
                PokemonStat(name: "defense", value: 50),
                PokemonStat(name: "special-attack", value: 50),
                PokemonStat(name: "special-defense", value: 50),
                PokemonStat(name: "speed", value: 50)
            ]
            self.selectedPokemonDetail = PokemonDetail(pokemon: pokemon, stats: fallbackStats, abilities: [])
        }
        
        isLoadingDetail = false
    }
}
