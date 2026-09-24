import Foundation

/// Represents the gender of a character in the Rick & Morty universe.
public enum RMGender: String, Codable, Sendable, Equatable, Hashable, CaseIterable, CustomStringConvertible {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"

    public var description: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .genderless:
            return "Genderless"
        case .unknown:
            return "Unknown"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue.lowercased() {
        case "female":
            self = .female
        case "male":
            self = .male
        case "genderless":
            self = .genderless
        default:
            self = .unknown
        }
    }
}
