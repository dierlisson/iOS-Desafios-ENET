import Foundation

/// Represents the origin location of a character.
public struct RMOrigin: Codable, Sendable, Equatable, Hashable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
