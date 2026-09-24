import Foundation
import Observation

@Observable
public final class TechEventsViewModel {
    public var events: [TechEvent] = []
    public var filteredEvents: [TechEvent] = []
    public var filterState = CompositeFilterState()
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var isFilterSheetPresented: Bool = false
    public var selectedEvent: TechEvent? = nil
    
    private let fetchEventsUseCase: FetchEventsUseCaseProtocol
    private let filterUseCase: FilterTechEventsUseCase
    private let repository: TechEventsRepositoryProtocol
    
    public init(
        fetchEventsUseCase: FetchEventsUseCaseProtocol,
        filterUseCase: FilterTechEventsUseCase = FilterTechEventsUseCase(),
        repository: TechEventsRepositoryProtocol
    ) {
        self.fetchEventsUseCase = fetchEventsUseCase
        self.filterUseCase = filterUseCase
        self.repository = repository
    }
    
    @MainActor
    public func loadEvents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await fetchEventsUseCase.execute()
            applyFilter()
        } catch {
            errorMessage = error.localizedDescription
            events = []
            filteredEvents = []
        }
        
        isLoading = false
    }
    
    public func applyFilter() {
        filteredEvents = filterUseCase.execute(events: events, filter: filterState)
    }
    
    @MainActor
    public func toggleBookmark(for event: TechEvent) async {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        do {
            let isNowBookmarked = try await repository.toggleBookmark(eventId: event.id)
            events[index].isBookmarked = isNowBookmarked
            applyFilter()
        } catch {
            errorMessage = "Não foi possível atualizar o favorito."
        }
    }
    
    public func resetFilters() {
        filterState.reset()
        applyFilter()
    }
    
    public func selectFormatFilter(_ format: EventFormat?) {
        filterState.selectedFormat = (filterState.selectedFormat == format) ? nil : format
        applyFilter()
    }
    
    public func selectModalityFilter(_ modality: EventModality?) {
        filterState.selectedModality = (filterState.selectedModality == modality) ? nil : modality
        applyFilter()
    }
    
    public func toggleFreeFilter() {
        filterState.onlyFree.toggle()
        applyFilter()
    }
    
    public func toggleBookmarkedFilter() {
        filterState.onlyBookmarked.toggle()
        applyFilter()
    }
}
