import Foundation

public struct Speaker: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let role: String
    public let company: String
    public let bio: String?
    public let avatarUrl: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        role: String,
        company: String,
        bio: String? = nil,
        avatarUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.company = company
        self.bio = bio
        self.avatarUrl = avatarUrl
    }
}
