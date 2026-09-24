import Foundation

public struct PokemonStat: Identifiable, Codable, Equatable, Hashable, Sendable {
    public var id: String { name }
    public let name: String
    public let value: Int
    
    public var displayName: String {
        switch name.lowercased() {
        case "hp": return "HP"
        case "attack": return "Ataque"
        case "defense": return "Defesa"
        case "special-attack": return "Atq. Esp."
        case "special-defense": return "Def. Esp."
        case "speed": return "Velocidade"
        default: return name.capitalized
        }
    }
    
    public var maxStatValue: Int {
        255
    }
    
    public var progressRatio: Double {
        min(max(Double(value) / Double(maxStatValue), 0.0), 1.0)
    }
    
    public init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}
