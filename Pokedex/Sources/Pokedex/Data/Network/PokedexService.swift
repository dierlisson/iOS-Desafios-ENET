import Foundation

public final class PokedexService: PokedexServiceProtocol, @unchecked Sendable {
    private let session: URLSession
    private let baseURL = "https://pokeapi.co/api/v2"
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> (items: [Pokemon], hasMore: Bool) {
        guard let url = URL(string: "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let listDTO = try JSONDecoder().decode(PokemonListDTO.self, from: data)
        let hasMore = listDTO.next != nil
        
        // Fetch details concurrently for all returned items to populate types and stats on list cards
        let items: [Pokemon] = try await withThrowingTaskGroup(of: PokemonDetail.self) { group in
            for itemDTO in listDTO.results {
                let identifier = itemDTO.name
                group.addTask {
                    return try await self.fetchPokemonDetail(nameOrID: identifier)
                }
            }
            
            var fetchedDetails: [PokemonDetail] = []
            for try await detail in group {
                fetchedDetails.append(detail)
            }
            return fetchedDetails.map { $0.pokemon }.sorted { $0.id < $1.id }
        }
        
        return (items: items, hasMore: hasMore)
    }
    
    public func fetchPokemonDetail(nameOrID: String) async throws -> PokemonDetail {
        let cleanIdentifier = nameOrID.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let url = URL(string: "\(baseURL)/pokemon/\(cleanIdentifier)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let detailDTO = try JSONDecoder().decode(PokemonDetailDTO.self, from: data)
        
        var speciesDescription: String? = nil
        if let speciesURL = URL(string: "\(baseURL)/pokemon-species/\(detailDTO.id)") {
            do {
                let (speciesData, speciesResponse) = try await session.data(from: speciesURL)
                if let httpSpeciesResp = speciesResponse as? HTTPURLResponse, (200...299).contains(httpSpeciesResp.statusCode) {
                    let speciesDTO = try JSONDecoder().decode(PokemonSpeciesDTO.self, from: speciesData)
                    speciesDescription = speciesDTO.portugueseOrEnglishFlavorText
                }
            } catch {
                // Silently fallback if species description call fails
            }
        }
        
        return detailDTO.toDomain(speciesDescription: speciesDescription)
    }
}

