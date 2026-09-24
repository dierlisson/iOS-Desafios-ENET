import Foundation

public struct CompositeFilterState: Equatable, Sendable {
    public var searchText: String
    public var selectedFormat: EventFormat?
    public var selectedModality: EventModality?
    public var onlyFree: Bool
    public var onlyBookmarked: Bool
    
    public init(
        searchText: String = "",
        selectedFormat: EventFormat? = nil,
        selectedModality: EventModality? = nil,
        onlyFree: Bool = false,
        onlyBookmarked: Bool = false
    ) {
        self.searchText = searchText
        self.selectedFormat = selectedFormat
        self.selectedModality = selectedModality
        self.onlyFree = onlyFree
        self.onlyBookmarked = onlyBookmarked
    }
    
    public var isFilteringActive: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedFormat != nil ||
        selectedModality != nil ||
        onlyFree ||
        onlyBookmarked
    }
    
    public var activeFilterCount: Int {
        var count = 0
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { count += 1 }
        if selectedFormat != nil { count += 1 }
        if selectedModality != nil { count += 1 }
        if onlyFree { count += 1 }
        if onlyBookmarked { count += 1 }
        return count
    }
    
    public mutating func reset() {
        searchText = ""
        selectedFormat = nil
        selectedModality = nil
        onlyFree = false
        onlyBookmarked = false
    }
}
