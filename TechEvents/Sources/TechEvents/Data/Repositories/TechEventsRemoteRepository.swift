import Foundation

public final class TechEventsRemoteRepository: TechEventsRepositoryProtocol, @unchecked Sendable {
    private let localRepository: TechEventsLocalRepository
    private let simulatedDelayNanoseconds: UInt64
    private let shouldFail: Bool
    
    public init(
        localRepository: TechEventsLocalRepository = TechEventsLocalRepository(),
        simulatedDelayNanoseconds: UInt64 = 300_000_000,
        shouldFail: Bool = false
    ) {
        self.localRepository = localRepository
        self.simulatedDelayNanoseconds = simulatedDelayNanoseconds
        self.shouldFail = shouldFail
    }
    
    public func fetchEvents() async throws -> [TechEvent] {
        if simulatedDelayNanoseconds > 0 {
            try? await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        }
        
        if shouldFail {
            throw NSError(
                domain: "TechEventsRemoteRepository",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Falha na conexão com o servidor remoto."]
            )
        }
        
        let rawEvents = MockEventsData.sampleEvents
        let savedBookmarks = await localRepository.getBookmarkedIds()
        
        return rawEvents.map { event in
            var mutable = event
            mutable.isBookmarked = savedBookmarks.contains(event.id)
            return mutable
        }
    }
    
    public func toggleBookmark(eventId: String) async throws -> Bool {
        return await localRepository.toggleBookmark(eventId: eventId)
    }
    
    public func getBookmarkedIds() async throws -> Set<String> {
        return await localRepository.getBookmarkedIds()
    }
}
