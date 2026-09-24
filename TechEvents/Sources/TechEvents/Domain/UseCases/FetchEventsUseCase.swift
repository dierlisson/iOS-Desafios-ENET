import Foundation

public struct FetchEventsUseCase: FetchEventsUseCaseProtocol {
    private let repository: TechEventsRepositoryProtocol
    
    public init(repository: TechEventsRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [TechEvent] {
        return try await repository.fetchEvents()
    }
}
