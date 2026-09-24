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
    public let gender: String
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
        gender: String,
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
