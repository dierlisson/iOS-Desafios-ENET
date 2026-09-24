import Foundation

/// Represents the species of a character in the Rick & Morty universe.
public struct RMSpecies: RawRepresentable, Codable, Sendable, Equatable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    public var description: String {
        rawValue.isEmpty ? "Unknown" : rawValue
    }

    public static let human: RMSpecies = "Human"
    public static let alien: RMSpecies = "Alien"
    public static let robot: RMSpecies = "Robot"
    public static let humanoid: RMSpecies = "Humanoid"
    public static let mythologicalCreature: RMSpecies = "Mythological Creature"
    public static let poopybutthole: RMSpecies = "Poopybutthole"
    public static let animal: RMSpecies = "Animal"
    public static let disease: RMSpecies = "Disease"
    public static let cronenberg: RMSpecies = "Cronenberg"
    public static let unknown: RMSpecies = "unknown"
}
