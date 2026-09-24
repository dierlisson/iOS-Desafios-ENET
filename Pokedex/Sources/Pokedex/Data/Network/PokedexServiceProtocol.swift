import Foundation

public protocol PokedexServiceProtocol: Sendable {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> (items: [Pokemon], hasMore: Bool)
    func fetchPokemonDetail(nameOrID: String) async throws -> PokemonDetail
}
