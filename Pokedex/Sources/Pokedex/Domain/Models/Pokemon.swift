import Foundation

public struct Pokemon: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let types: [PokemonType]
    public let imageUrl: String
    public let heightDecimeters: Int?
    public let weightHectograms: Int?
    
    public init(
        id: Int,
        name: String,
        types: [PokemonType],
        imageUrl: String,
        heightDecimeters: Int? = nil,
        weightHectograms: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.types = types
        self.imageUrl = imageUrl
        self.heightDecimeters = heightDecimeters
        self.weightHectograms = weightHectograms
    }
    
    public var formattedID: String {
        String(format: "#%03d", id)
    }
    
    public var displayName: String {
        name.capitalized
    }
    
    public var primaryType: PokemonType {
        types.first ?? .normal
    }
    
    public var heightMetersText: String {
        guard let height = heightDecimeters else { return "-" }
        let meters = Double(height) / 10.0
        return String(format: "%.1f m", meters)
    }
    
    public var weightKilogramsText: String {
        guard let weight = weightHectograms else { return "-" }
        let kg = Double(weight) / 10.0
        return String(format: "%.1f kg", kg)
    }
}
