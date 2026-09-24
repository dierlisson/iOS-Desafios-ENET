import Foundation

public struct ScheduleSlot: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let startTime: String
    public let endTime: String
    public let room: String?
    public let speaker: Speaker?
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        startTime: String,
        endTime: String,
        room: String? = nil,
        speaker: Speaker? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.room = room
        self.speaker = speaker
    }
}
