import Foundation

public final class MockPokedexService: PokedexServiceProtocol, @unchecked Sendable {
    public var shouldFail: Bool
    public var simulatedDelay: UInt64
    public var mockPokemons: [Pokemon]
    public var mockDetails: [Int: PokemonDetail]
    
    public init(
        shouldFail: Bool = false,
        simulatedDelay: UInt64 = 0,
        mockPokemons: [Pokemon] = MockPokedexData.samplePokemons,
        mockDetails: [Int: PokemonDetail] = MockPokedexData.sampleDetails
    ) {
        self.shouldFail = shouldFail
        self.simulatedDelay = simulatedDelay
        self.mockPokemons = mockPokemons
        self.mockDetails = mockDetails
    }
    
    public func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> (items: [Pokemon], hasMore: Bool) {
        if simulatedDelay > 0 {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }
        
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        
        let start = min(offset, mockPokemons.count)
        let end = min(offset + limit, mockPokemons.count)
        let page = Array(mockPokemons[start..<end])
        let hasMore = end < mockPokemons.count
        
        return (items: page, hasMore: hasMore)
    }
    
    public func fetchPokemonDetail(nameOrID: String) async throws -> PokemonDetail {
        if simulatedDelay > 0 {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }
        
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        
        let clean = nameOrID.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let id = Int(clean), let detail = mockDetails[id] {
            return detail
        }
        
        if let found = mockPokemons.first(where: { $0.name.lowercased() == clean || "\($0.id)" == clean }) {
            if let detail = mockDetails[found.id] {
                return detail
            }
            return PokemonDetail(
                pokemon: found,
                stats: [
                    PokemonStat(name: "hp", value: 45),
                    PokemonStat(name: "attack", value: 49),
                    PokemonStat(name: "defense", value: 49),
                    PokemonStat(name: "special-attack", value: 65),
                    PokemonStat(name: "special-defense", value: 65),
                    PokemonStat(name: "speed", value: 45)
                ],
                abilities: ["Overgrow", "Chlorophyll"]
            )
        }
        
        throw URLError(.resourceUnavailable)
    }
}

public enum MockPokedexData {
    public static let bulbasaur = Pokemon(
        id: 1,
        name: "bulbasaur",
        types: [.grass, .poison],
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
        heightDecimeters: 7,
        weightHectograms: 69
    )
    
    public static let charmander = Pokemon(
        id: 4,
        name: "charmander",
        types: [.fire],
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png",
        heightDecimeters: 6,
        weightHectograms: 85
    )
    
    public static let squirtle = Pokemon(
        id: 7,
        name: "squirtle",
        types: [.water],
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png",
        heightDecimeters: 5,
        weightHectograms: 90
    )
    
    public static let pikachu = Pokemon(
        id: 25,
        name: "pikachu",
        types: [.electric],
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
        heightDecimeters: 4,
        weightHectograms: 60
    )
    
    public static let samplePokemons: [Pokemon] = [bulbasaur, charmander, squirtle, pikachu]
    
    public static let sampleDetails: [Int: PokemonDetail] = [
        1: PokemonDetail(
            pokemon: bulbasaur,
            stats: [
                PokemonStat(name: "hp", value: 45),
                PokemonStat(name: "attack", value: 49),
                PokemonStat(name: "defense", value: 49),
                PokemonStat(name: "special-attack", value: 65),
                PokemonStat(name: "special-defense", value: 65),
                PokemonStat(name: "speed", value: 45)
            ],
            abilities: ["Overgrow", "Chlorophyll"],
            speciesDescription: "Há uma semente de planta em suas costas desde o nascimento. Ela cresce lentamente conforme o pokémon se desenvolve."
        ),
        4: PokemonDetail(
            pokemon: charmander,
            stats: [
                PokemonStat(name: "hp", value: 39),
                PokemonStat(name: "attack", value: 52),
                PokemonStat(name: "defense", value: 43),
                PokemonStat(name: "special-attack", value: 60),
                PokemonStat(name: "special-defense", value: 50),
                PokemonStat(name: "speed", value: 65)
            ],
            abilities: ["Blaze", "Solar Power"],
            speciesDescription: "A chama na ponta de sua cauda indica a sua força vital. Se ela se apagar, o pokémon perece."
        ),
        7: PokemonDetail(
            pokemon: squirtle,
            stats: [
                PokemonStat(name: "hp", value: 44),
                PokemonStat(name: "attack", value: 48),
                PokemonStat(name: "defense", value: 65),
                PokemonStat(name: "special-attack", value: 50),
                PokemonStat(name: "special-defense", value: 64),
                PokemonStat(name: "speed", value: 43)
            ],
            abilities: ["Torrent", "Rain Dish"],
            speciesDescription: "Seu casco não serve apenas para proteção. Suas ranhuras diminuem a resistência na água."
        ),
        25: PokemonDetail(
            pokemon: pikachu,
            stats: [
                PokemonStat(name: "hp", value: 35),
                PokemonStat(name: "attack", value: 55),
                PokemonStat(name: "defense", value: 40),
                PokemonStat(name: "special-attack", value: 50),
                PokemonStat(name: "special-defense", value: 50),
                PokemonStat(name: "speed", value: 90)
            ],
            abilities: ["Static", "Lightning Rod"],
            speciesDescription: "Armazena eletricidade em suas bochechas vermelhas. Quando ameaçado, descarrega choques intensos."
        )
    ]
}
