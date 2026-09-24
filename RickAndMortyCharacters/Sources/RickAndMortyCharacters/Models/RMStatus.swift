import Foundation

/// Represents the status of a character in the Rick & Morty universe.
public enum RMStatus: String, Codable, Sendable, Equatable, Hashable, CaseIterable, CustomStringConvertible {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"

    public var description: String {
        switch self {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue.lowercased() {
        case "alive":
            self = .alive
        case "dead":
            self = .dead
        default:
            self = .unknown
        }
    }
}
