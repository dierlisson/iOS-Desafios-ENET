import Foundation
import SwiftUI
import Observation

@Observable
public final class EventsViewModel {
    public var events: [Event] = []
    public var searchText: String = ""
    public var selectedCategory: EventCategory = .all
    public var selectedSort: SortOption = .dateAsc
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var favoriteIDs: Set<UUID> = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private let service: EventServiceProtocol
    private let favoritesKey = "lista_eventos_favorite_ids"
    
    public init(
        service: EventServiceProtocol = EventService(),
        initialCategory: EventCategory = .all,
        initialSearchText: String = "",
        initialSort: SortOption = .dateAsc
    ) {
        self.service = service
        self.selectedCategory = initialCategory
        self.searchText = initialSearchText
        self.selectedSort = initialSort
        loadFavorites()
    }
    
    @MainActor
    public func loadEvents() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await service.fetchEvents()
        } catch {
            errorMessage = "Não foi possível carregar a lista de eventos."
        }
        isLoading = false
    }
    
    public var filteredEvents: [Event] {
        events.filter { event in
            let matchesCategory = (selectedCategory == .all) || (event.category == selectedCategory)
            let matchesSearch = searchText.isEmpty ||
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.organizer.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }.sorted { first, second in
            switch selectedSort {
            case .dateAsc:
                return first.date < second.date
            case .dateDesc:
                return first.date > second.date
            case .titleAsc:
                return first.title.localizedCompare(second.title) == .orderedAscending
            }
        }
    }
    
    public func isFavorite(_ event: Event) -> Bool {
        favoriteIDs.contains(event.id)
    }
    
    public func toggleFavorite(for event: Event) {
        if favoriteIDs.contains(event.id) {
            favoriteIDs.remove(event.id)
        } else {
            favoriteIDs.insert(event.id)
        }
    }
    
    public func resetFilters() {
        searchText = ""
        selectedCategory = .all
        selectedSort = .dateAsc
    }
    
    private func saveFavorites() {
        let strings = favoriteIDs.map { $0.uuidString }
        UserDefaults.standard.set(strings, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let strings = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteIDs = Set(strings.compactMap { UUID(uuidString: $0) })
        }
    }
}
