import Foundation

public struct FilterTechEventsUseCase: Sendable {
    public init() {}
    
    public func execute(events: [TechEvent], filter: CompositeFilterState) -> [TechEvent] {
        return events.filter { event in
            // 1. Keyword search
            let trimmedSearch = filter.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSearch.isEmpty {
                let query = trimmedSearch.lowercased()
                let matchesTitle = event.title.lowercased().contains(query)
                let matchesSummary = event.summary.lowercased().contains(query)
                let matchesDescription = event.fullDescription.lowercased().contains(query)
                let matchesLocation = event.location.lowercased().contains(query)
                let matchesSpeaker = event.speakers.contains { speaker in
                    speaker.name.lowercased().contains(query) || speaker.company.lowercased().contains(query)
                }
                
                if !(matchesTitle || matchesSummary || matchesDescription || matchesLocation || matchesSpeaker) {
                    return false
                }
            }
            
            // 2. Event Format filter
            if let selectedFormat = filter.selectedFormat, event.format != selectedFormat {
                return false
            }
            
            // 3. Event Modality filter
            if let selectedModality = filter.selectedModality, event.modality != selectedModality {
                return false
            }
            
            // 4. Free events filter
            if filter.onlyFree && !event.isFree {
                return false
            }
            
            // 5. Bookmarked events filter
            if filter.onlyBookmarked && !event.isBookmarked {
                return false
            }
            
            return true
        }
    }
}
