import Foundation

/// Represents a Rick & Morty character model matching the API contract.
public struct RMCharacter: Identifiable, Codable, Sendable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let status: RMStatus
    public let species: RMSpecies
    public let type: String
    public let gender: RMGender
    public let origin: RMOrigin
    public let location: RMLocation
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String

    public init(
        id: Int,
        name: String,
        status: RMStatus,
        species: RMSpecies,
        type: String,
        gender: RMGender,
        origin: RMOrigin,
        location: RMLocation,
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
