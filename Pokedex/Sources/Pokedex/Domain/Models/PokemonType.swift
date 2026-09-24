import SwiftUI

public enum PokemonType: String, Codable, CaseIterable, Identifiable, Sendable {
    case normal
    case fire
    case water
    case grass
    case electric
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case steel
    case fairy
    case dark
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .fire: return "Fogo"
        case .water: return "Água"
        case .grass: return "Planta"
        case .electric: return "Elétrico"
        case .ice: return "Gelo"
        case .fighting: return "Lutador"
        case .poison: return "Veneno"
        case .ground: return "Terrestre"
        case .flying: return "Voador"
        case .psychic: return "Psíquico"
        case .bug: return "Inseto"
        case .rock: return "Pedra"
        case .ghost: return "Fantasma"
        case .dragon: return "Dragão"
        case .steel: return "Aço"
        case .fairy: return "Fada"
        case .dark: return "Sombrio"
        }
    }
    
    public var color: Color {
        switch self {
        case .grass: return Color(red: 0.47, green: 0.78, blue: 0.38)
        case .fire: return Color(red: 0.93, green: 0.51, blue: 0.20)
        case .water: return Color(red: 0.40, green: 0.56, blue: 0.94)
        case .electric: return Color(red: 0.97, green: 0.82, blue: 0.20)
        case .ice: return Color(red: 0.59, green: 0.85, blue: 0.84)
        case .poison: return Color(red: 0.64, green: 0.28, blue: 0.64)
        case .ground: return Color(red: 0.89, green: 0.75, blue: 0.40)
        case .flying: return Color(red: 0.66, green: 0.56, blue: 0.94)
        case .psychic: return Color(red: 0.97, green: 0.33, blue: 0.53)
        case .bug: return Color(red: 0.65, green: 0.73, blue: 0.10)
        case .rock: return Color(red: 0.72, green: 0.63, blue: 0.22)
        case .ghost: return Color(red: 0.45, green: 0.35, blue: 0.61)
        case .dragon: return Color(red: 0.43, green: 0.21, blue: 0.97)
        case .steel: return Color(red: 0.72, green: 0.72, blue: 0.81)
        case .fairy: return Color(red: 0.93, green: 0.60, blue: 0.68)
        case .fighting: return Color(red: 0.76, green: 0.19, blue: 0.16)
        case .normal: return Color(red: 0.66, green: 0.65, blue: 0.48)
        case .dark: return Color(red: 0.44, green: 0.34, blue: 0.27)
        }
    }
    
    public var iconName: String {
        switch self {
        case .fire: return "flame.fill"
        case .water: return "drop.fill"
        case .grass: return "leaf.fill"
        case .electric: return "bolt.fill"
        case .ice: return "snowflake"
        case .poison: return "cross.vial.fill"
        case .ground: return "mountain.2.fill"
        case .flying: return "wind"
        case .psychic: return "eye.fill"
        case .bug: return "ant.fill"
        case .rock: return "circle.hexagongrid.fill"
        case .ghost: return "ghost.fill"
        case .dragon: return "shield.pattern.checkered"
        case .steel: return "gearshape.fill"
        case .fairy: return "sparkles"
        case .fighting: return "hand.raised.fill"
        case .normal: return "circle.fill"
        case .dark: return "moon.fill"
        }
    }
}
