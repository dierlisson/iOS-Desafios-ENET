import Foundation

public enum EventModality: String, CaseIterable, Codable, Sendable, Identifiable {
    case conference
    case meetup
    case hackathon
    case workshop
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .conference:
            return "Conferência"
        case .meetup:
            return "Meetup"
        case .hackathon:
            return "Hackathon"
        case .workshop:
            return "Workshop"
        }
    }
    
    public var iconName: String {
        switch self {
        case .conference:
            return "megaphone.fill"
        case .meetup:
            return "bubble.left.and.bubble.right.fill"
        case .hackathon:
            return "terminal.fill"
        case .workshop:
            return "wrench.and.screwdriver.fill"
        }
    }
}
