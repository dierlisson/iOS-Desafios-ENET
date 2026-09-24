import XCTest
@testable import ListaDeEventos

final class ListaDeEventosTests: XCTestCase {
    
    @MainActor
    func testFilteringByCategory() async {
        let viewModel = EventsViewModel()
        await viewModel.loadEvents()
        
        XCTAssertFalse(viewModel.events.isEmpty)
        
        viewModel.selectedCategory = .tech
        let techEvents = viewModel.filteredEvents
        
        XCTAssertTrue(techEvents.allSatisfy { $0.category == .tech })
    }
    
    @MainActor
    func testSearchFiltering() async {
        let viewModel = EventsViewModel()
        await viewModel.loadEvents()
        
        viewModel.searchText = "WWDC"
        let searchResults = viewModel.filteredEvents
        
        XCTAssertEqual(searchResults.count, 1)
        XCTAssertTrue(searchResults.first?.title.contains("WWDC") == true)
    }
    
    @MainActor
    func testFavoriteToggle() async {
        let viewModel = EventsViewModel()
        await viewModel.loadEvents()
        
        guard let firstEvent = viewModel.events.first else {
            XCTFail("No events found")
            return
        }
        
        XCTAssertFalse(viewModel.isFavorite(firstEvent))
        viewModel.toggleFavorite(for: firstEvent)
        XCTAssertTrue(viewModel.isFavorite(firstEvent))
        viewModel.toggleFavorite(for: firstEvent)
        XCTAssertFalse(viewModel.isFavorite(firstEvent))
    }
}
