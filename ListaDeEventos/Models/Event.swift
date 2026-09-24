import Foundation

public enum EventCategory: String, CaseIterable, Identifiable, Codable {
    case all = "Todos"
    case tech = "Tecnologia"
    case design = "Design"
    case business = "Negócios"
    case workshop = "Workshop"
    case career = "Carreira"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .all: return "sparkles"
        case .tech: return "laptopcomputer"
        case .design: return "paintpalette.fill"
        case .business: return "briefcase.fill"
        case .workshop: return "hammer.fill"
        case .career: return "person.3.fill"
        }
    }
}

public enum SortOption: String, CaseIterable, Identifiable {
    case dateAsc = "Data (Mais Próxima)"
    case dateDesc = "Data (Mais Distante)"
    case titleAsc = "Nome (A-Z)"
    
    public var id: String { rawValue }
}

public struct Event: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public let title: String
    public let subtitle: String
    public let date: Date
    public let location: String
    public let address: String
    public let category: EventCategory
    public let description: String
    public let iconName: String
    public let price: String
    public let organizer: String
    public let maxCapacity: Int
    public let attendeesCount: Int
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        date: Date,
        location: String,
        address: String,
        category: EventCategory,
        description: String,
        iconName: String,
        price: String,
        organizer: String,
        maxCapacity: Int = 100,
        attendeesCount: Int = 42
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.location = location
        self.address = address
        self.category = category
        self.description = description
        self.iconName = iconName
        self.price = price
        self.organizer = organizer
        self.maxCapacity = maxCapacity
        self.attendeesCount = attendeesCount
    }
}
