import Foundation

public protocol FetchEventsUseCaseProtocol: Sendable {
    func execute() async throws -> [TechEvent]
}
