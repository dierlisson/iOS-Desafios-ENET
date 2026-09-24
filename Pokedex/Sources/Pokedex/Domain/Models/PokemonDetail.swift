import Foundation

public struct PokemonDetail: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let pokemon: Pokemon
    public let stats: [PokemonStat]
    public let abilities: [String]
    public let speciesDescription: String?
    
    public init(
        pokemon: Pokemon,
        stats: [PokemonStat],
        abilities: [String] = [],
        speciesDescription: String? = nil
    ) {
        self.pokemon = pokemon
        self.stats = stats
        self.abilities = abilities
        self.speciesDescription = speciesDescription
    }
    
    public var id: Int { pokemon.id }
}
