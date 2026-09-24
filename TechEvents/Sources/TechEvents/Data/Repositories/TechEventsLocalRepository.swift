import Foundation

public final class TechEventsLocalRepository: @unchecked Sendable {
    private var bookmarkedIds: Set<String>
    private let lock = NSLock()
    
    public init(initialBookmarks: Set<String> = []) {
        self.bookmarkedIds = initialBookmarks
    }
    
    public func getBookmarkedIds() async -> Set<String> {
        lock.lock()
        defer { lock.unlock() }
        return bookmarkedIds
    }
    
    public func toggleBookmark(eventId: String) async -> Bool {
        lock.lock()
        defer { lock.unlock() }
        if bookmarkedIds.contains(eventId) {
            bookmarkedIds.remove(eventId)
            return false
        } else {
            bookmarkedIds.insert(eventId)
            return true
        }
    }
    
    public func setBookmarked(eventId: String, isBookmarked: Bool) async {
        lock.lock()
        defer { lock.unlock() }
        if isBookmarked {
            bookmarkedIds.insert(eventId)
        } else {
            bookmarkedIds.remove(eventId)
        }
    }
}
