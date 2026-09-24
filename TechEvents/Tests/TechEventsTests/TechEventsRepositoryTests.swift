import XCTest
@testable import TechEvents

final class TechEventsRepositoryTests: XCTestCase {
    
    func test_localRepository_toggleBookmark_updatesBookmarksSet() async {
        let localRepo = TechEventsLocalRepository(initialBookmarks: ["event-1"])
        
        let initialBookmarks = await localRepo.getBookmarkedIds()
        XCTAssertTrue(initialBookmarks.contains("event-1"))
        
        let removed = await localRepo.toggleBookmark(eventId: "event-1")
        XCTAssertFalse(removed)
        let afterRemove = await localRepo.getBookmarkedIds()
        XCTAssertFalse(afterRemove.contains("event-1"))
        
        let added = await localRepo.toggleBookmark(eventId: "event-2")
        XCTAssertTrue(added)
        let afterAdd = await localRepo.getBookmarkedIds()
        XCTAssertTrue(afterAdd.contains("event-2"))
    }
    
    func test_remoteRepository_fetchEvents_success_returnsEventsWithLocalBookmarkState() async throws {
        let localRepo = TechEventsLocalRepository(initialBookmarks: ["event-2"])
        let remoteRepo = TechEventsRemoteRepository(
            localRepository: localRepo,
            simulatedDelayNanoseconds: 0
        )
        
        let events = try await remoteRepo.fetchEvents()
        
        XCTAssertFalse(events.isEmpty)
        if let event2 = events.first(where: { $0.id == "event-2" }) {
            XCTAssertTrue(event2.isBookmarked)
        } else {
            XCTFail("Event 2 expected in sample mock data")
        }
    }
    
    func test_remoteRepository_fetchEvents_failure_throwsError() async {
        let remoteRepo = TechEventsRemoteRepository(
            simulatedDelayNanoseconds: 0,
            shouldFail: true
        )
        
        do {
            _ = try await remoteRepo.fetchEvents()
            XCTFail("Expected fetchEvents to fail, but it succeeded.")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
