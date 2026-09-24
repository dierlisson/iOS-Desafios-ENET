import Foundation

public struct PokemonListDTO: Codable, Sendable {
    public let count: Int
    public let next: String?
    public let results: [PokemonListItemDTO]
}

public struct PokemonListItemDTO: Codable, Sendable {
    public let name: String
    public let url: String
    
    public var idFromURL: Int? {
        // Example URL: "https://pokeapi.co/api/v2/pokemon/1/"
        let components = url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).components(separatedBy: "/")
        if let last = components.last, let id = Int(last) {
            return id
        }
        return nil
    }
}

public struct PokemonDetailDTO: Codable, Sendable {
    public let id: Int
    public let name: String
    public let height: Int
    public let weight: Int
    public let types: [PokemonTypeSlotDTO]
    public let stats: [PokemonStatDTO]
    public let abilities: [PokemonAbilitySlotDTO]
    
    public var officialArtworkURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    public func toDomain() -> PokemonDetail {
        let domainTypes = types.compactMap { PokemonType(rawValue: $0.type.name.lowercased()) }
        let domainStats = stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) }
        let domainAbilities = abilities.map { $0.ability.name.capitalized }
        
        let pokemon = Pokemon(
            id: id,
            name: name,
            types: domainTypes.isEmpty ? [.normal] : domainTypes,
            imageUrl: officialArtworkURL,
            heightDecimeters: height,
            weightHectograms: weight
        )
        
        return PokemonDetail(
            pokemon: pokemon,
            stats: domainStats,
            abilities: domainAbilities
        )
    }
}

public struct PokemonTypeSlotDTO: Codable, Sendable {
    public let slot: Int
    public let type: NamedResourceDTO
}

public struct PokemonStatDTO: Codable, Sendable {
    public let baseStat: Int
    public let stat: NamedResourceDTO
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

public struct PokemonAbilitySlotDTO: Codable, Sendable {
    public let ability: NamedResourceDTO
}

public struct NamedResourceDTO: Codable, Sendable {
    public let name: String
    public let url: String
}
