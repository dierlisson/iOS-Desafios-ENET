import Foundation
import SwiftUI

public enum RMStatus: String, Codable, CaseIterable, Identifiable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .alive: return "Vivo"
        case .dead: return "Morto"
        case .unknown: return "Desconhecido"
        }
    }
    
    public var color: Color {
        switch self {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}

public enum RMGender: String, Codable, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .female: return "Feminino"
        case .male: return "Masculino"
        case .genderless: return "Sem gênero"
        case .unknown: return "Desconhecido"
        }
    }
    
    public var color: Color {
        switch self {
        case .female: return .pink
        case .male: return .blue
        case .genderless: return .purple
        case .unknown: return .orange
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public struct RMLocationRef: Codable, Hashable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct RMPageInfo: Codable {
    public let count: Int
    public let pages: Int
    public let next: String?
    public let prev: String?
}

public struct RMCharacterResponse: Codable {
    public let info: RMPageInfo
    public let results: [RMCharacter]
}

public struct RMCharacter: Identifiable, Codable, Hashable {
    public let id: Int
    public let name: String
    public let status: RMStatus
    public let species: String
    public let type: String
    public let gender: RMGender
    public let origin: RMLocationRef
    public let location: RMLocationRef
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
    
    public init(
        id: Int,
        name: String,
        status: RMStatus,
        species: String,
        type: String,
        gender: RMGender,
        origin: RMLocationRef,
        location: RMLocationRef,
        image: String,
        episode: [String],
        url: String,
        created: String
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}
