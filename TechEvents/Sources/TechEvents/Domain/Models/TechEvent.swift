import Foundation

public struct TechEvent: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let fullDescription: String
    public let date: Date
    public let dateFormatted: String
    public let location: String
    public let format: EventFormat
    public let modality: EventModality
    public let isFree: Bool
    public let price: Double?
    public let bannerUrl: String?
    public let speakers: [Speaker]
    public let schedule: [ScheduleSlot]
    public var isBookmarked: Bool
    
    public init(
        id: String,
        title: String,
        summary: String,
        fullDescription: String,
        date: Date,
        dateFormatted: String,
        location: String,
        format: EventFormat,
        modality: EventModality,
        isFree: Bool,
        price: Double? = nil,
        bannerUrl: String? = nil,
        speakers: [Speaker] = [],
        schedule: [ScheduleSlot] = [],
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.fullDescription = fullDescription
        self.date = date
        self.dateFormatted = dateFormatted
        self.location = location
        self.format = format
        self.modality = modality
        self.isFree = isFree
        self.price = price
        self.bannerUrl = bannerUrl
        self.speakers = speakers
        self.schedule = schedule
        self.isBookmarked = isBookmarked
    }
    
    public var priceText: String {
        if isFree {
            return "Gratuito"
        } else if let price = price {
            return String(format: "R$ %.2f", price)
        } else {
            return "Pago"
        }
    }
}
