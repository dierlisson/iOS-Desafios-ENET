import XCTest
@testable import TechEvents

final class FilterTechEventsUseCaseTests: XCTestCase {
    private var sut: FilterTechEventsUseCase!
    private var sampleEvents: [TechEvent]!
    
    override func setUp() {
        super.setUp()
        sut = FilterTechEventsUseCase()
        sampleEvents = [
            TechEvent(
                id: "1",
                title: "iOS Brasil Conf",
                summary: "Conferência presencial Swift",
                fullDescription: "Desenvolvimento de software em São Paulo com palestrante renomado",
                date: Date(),
                dateFormatted: "15/10/2026",
                location: "São Paulo - SP",
                format: .presencial,
                modality: .conference,
                isFree: false,
                price: 299.0,
                speakers: [Speaker(name: "Ana Clara", role: "Engineer", company: "Apple")],
                isBookmarked: true
            ),
            TechEvent(
                id: "2",
                title: "SwiftUI Masterclass",
                summary: "Workshop online gratuito",
                fullDescription: "Aprenda SwiftUI reativo e macros do Swift 6",
                date: Date(),
                dateFormatted: "05/10/2026",
                location: "Online Zoom",
                format: .online,
                modality: .workshop,
                isFree: true,
                price: 0.0,
                speakers: [Speaker(name: "Mariana Costa", role: "UI Dev", company: "Studio")],
                isBookmarked: false
            ),
            TechEvent(
                id: "3",
                title: "AI Developers Meetup",
                summary: "Encontro híbrido de inteligência artificial",
                fullDescription: "Modelos LLM e Machine Learning no celular",
                date: Date(),
                dateFormatted: "20/10/2026",
                location: "CUBO Itaú",
                format: .hybrid,
                modality: .meetup,
                isFree: true,
                price: 0.0,
                speakers: [Speaker(name: "Gabriel Santos", role: "AI Researcher", company: "DeepTech")],
                isBookmarked: false
            ),
            TechEvent(
                id: "4",
                title: "Hackathon Mobile 2026",
                summary: "Maratona presencial de código",
                fullDescription: "48 horas de desenvolvimento de startups",
                date: Date(),
                dateFormatted: "30/10/2026",
                location: "Florianópolis - SC",
                format: .presencial,
                modality: .hackathon,
                isFree: true,
                price: 0.0,
                speakers: [],
                isBookmarked: true
            )
        ]
    }
    
    override func tearDown() {
        sut = nil
        sampleEvents = nil
        super.tearDown()
    }
    
    // MARK: - Single Filter Tests
    
    func test_filterBySearchText_matchingTitle_returnsMatchingEvents() {
        let filter = CompositeFilterState(searchText: "SwiftUI")
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "2")
    }
    
    func test_filterBySearchText_matchingSpeakerName_returnsMatchingEvents() {
        let filter = CompositeFilterState(searchText: "Ana Clara")
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
    
    func test_filterByFormat_online_returnsOnlyOnlineEvents() {
        let filter = CompositeFilterState(selectedFormat: .online)
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.format, .online)
    }
    
    func test_filterByModality_workshop_returnsOnlyWorkshops() {
        let filter = CompositeFilterState(selectedModality: .workshop)
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.modality, .workshop)
    }
    
    func test_filterByOnlyFree_returnsOnlyFreeEvents() {
        let filter = CompositeFilterState(onlyFree: true)
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.allSatisfy { $0.isFree })
    }
    
    func test_filterByOnlyBookmarked_returnsOnlyBookmarkedEvents() {
        let filter = CompositeFilterState(onlyBookmarked: true)
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.allSatisfy { $0.isBookmarked })
    }
    
    // MARK: - Composite Filter Tests
    
    func test_compositeFilter_combiningFormatModalityAndFree_returnsFilteredEvents() {
        let filter = CompositeFilterState(
            selectedFormat: .presencial,
            onlyFree: true
        )
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "4")
    }
    
    func test_compositeFilter_withSearchTextFormatAndBookmarked_returnsExpectedEvent() {
        let filter = CompositeFilterState(
            searchText: "Brasil",
            selectedFormat: .presencial,
            onlyBookmarked: true
        )
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
    
    func test_compositeFilter_noMatches_returnsEmptyArray() {
        let filter = CompositeFilterState(
            searchText: "Android",
            selectedFormat: .online
        )
        let result = sut.execute(events: sampleEvents, filter: filter)
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_resetFilter_returnsAllEvents() {
        var filter = CompositeFilterState(
            searchText: "NonExistent",
            selectedFormat: .online,
            onlyFree: true
        )
        filter.reset()
        
        let result = sut.execute(events: sampleEvents, filter: filter)
        XCTAssertEqual(result.count, 4)
        XCTAssertFalse(filter.isFilteringActive)
    }
}
