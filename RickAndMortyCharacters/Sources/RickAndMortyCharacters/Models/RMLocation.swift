import Foundation

/// Represents the current location of a character.
public struct RMLocation: Codable, Sendable, Equatable, Hashable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
