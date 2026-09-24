import Foundation

/// Info block for paginated Rick & Morty API responses.
public struct RMPageInfo: Codable, Sendable, Equatable, Hashable {
    public let count: Int
    public let pages: Int
    public let next: String?
    public let prev: String?

    public init(count: Int, pages: Int, next: String?, prev: String?) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }

    public static let empty = RMPageInfo(count: 0, pages: 0, next: nil, prev: nil)
}

/// Paginated API response for character queries.
public struct CharacterResponse: Codable, Sendable, Equatable, Hashable {
    public let info: RMPageInfo
    public let results: [RMCharacter]

    public init(info: RMPageInfo, results: [RMCharacter]) {
        self.info = info
        self.results = results
    }

    public static let empty = CharacterResponse(info: .empty, results: [])
}

/// Convenience alias matching RM prefix naming convention.
public typealias RMCharacterResponse = CharacterResponse
