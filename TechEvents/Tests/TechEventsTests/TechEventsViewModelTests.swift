import XCTest
@testable import TechEvents

final class TechEventsViewModelTests: XCTestCase {
    
    @MainActor
    func test_viewModel_loadEvents_success_populatesEventsAndFilteredEvents() async {
        let localRepo = TechEventsLocalRepository()
        let remoteRepo = TechEventsRemoteRepository(localRepository: localRepo, simulatedDelayNanoseconds: 0)
        let useCase = FetchEventsUseCase(repository: remoteRepo)
        let vm = TechEventsViewModel(fetchEventsUseCase: useCase, repository: remoteRepo)
        
        XCTAssertTrue(vm.events.isEmpty)
        XCTAssertFalse(vm.isLoading)
        
        await vm.loadEvents()
        
        XCTAssertFalse(vm.events.isEmpty)
        XCTAssertEqual(vm.events.count, vm.filteredEvents.count)
        XCTAssertNil(vm.errorMessage)
    }
    
    @MainActor
    func test_viewModel_toggleBookmark_updatesEventState() async {
        let localRepo = TechEventsLocalRepository()
        let remoteRepo = TechEventsRemoteRepository(localRepository: localRepo, simulatedDelayNanoseconds: 0)
        let useCase = FetchEventsUseCase(repository: remoteRepo)
        let vm = TechEventsViewModel(fetchEventsUseCase: useCase, repository: remoteRepo)
        
        await vm.loadEvents()
        
        guard let firstEvent = vm.events.first else {
            XCTFail("Events should not be empty")
            return
        }
        
        let initialBookmarkStatus = firstEvent.isBookmarked
        await vm.toggleBookmark(for: firstEvent)
        
        let updatedEvent = vm.events.first(where: { $0.id == firstEvent.id })
        XCTAssertEqual(updatedEvent?.isBookmarked, !initialBookmarkStatus)
    }
    
    @MainActor
    func test_viewModel_resetFilters_clearsAllFilters() async {
        let localRepo = TechEventsLocalRepository()
        let remoteRepo = TechEventsRemoteRepository(localRepository: localRepo, simulatedDelayNanoseconds: 0)
        let useCase = FetchEventsUseCase(repository: remoteRepo)
        let vm = TechEventsViewModel(fetchEventsUseCase: useCase, repository: remoteRepo)
        
        await vm.loadEvents()
        
        vm.filterState.searchText = "SwiftUI"
        vm.filterState.selectedFormat = .online
        vm.filterState.onlyFree = true
        vm.applyFilter()
        
        XCTAssertTrue(vm.filterState.isFilteringActive)
        
        vm.resetFilters()
        
        XCTAssertFalse(vm.filterState.isFilteringActive)
        XCTAssertEqual(vm.events.count, vm.filteredEvents.count)
    }
}
