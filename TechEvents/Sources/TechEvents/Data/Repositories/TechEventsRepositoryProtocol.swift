import Foundation

public protocol TechEventsRepositoryProtocol: Sendable {
    func fetchEvents() async throws -> [TechEvent]
    func toggleBookmark(eventId: String) async throws -> Bool
    func getBookmarkedIds() async throws -> Set<String>
}
