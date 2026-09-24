import XCTest
@testable import TechEvents

final class TechEventMockTests: XCTestCase {
    func test_mockDefaultInitialization_createsValidEvent() {
        let mockEvent = TechEvent.mock()
        
        XCTAssertEqual(mockEvent.id, "mock-event-1")
        XCTAssertEqual(mockEvent.title, "Evento de Teste Swift")
        XCTAssertEqual(mockEvent.format, .presencial)
        XCTAssertEqual(mockEvent.modality, .conference)
        XCTAssertTrue(mockEvent.isFree)
        XCTAssertEqual(mockEvent.priceText, "Gratuito")
        XCTAssertFalse(mockEvent.isBookmarked)
        XCTAssertTrue(mockEvent.speakers.isEmpty)
        XCTAssertTrue(mockEvent.schedule.isEmpty)
    }
    
    func test_mockCustomValues_overridesDefaultsCorrectly() {
        let customSpeaker = Speaker(
            id: "spk-1",
            name: "Ana Silva",
            role: "Staff Engineer",
            company: "Tech Co"
        )
        
        let customSlot = ScheduleSlot(
            id: "slot-1",
            title: "Abertura",
            startTime: "09:00",
            endTime: "10:00",
            speaker: customSpeaker
        )
        
        let customMock = TechEvent.mock(
            id: "custom-999",
            title: "WWDC Keynote Watch",
            format: .online,
            modality: .workshop,
            isFree: false,
            price: 99.90,
            speakers: [customSpeaker],
            schedule: [customSlot],
            isBookmarked: true
        )
        
        XCTAssertEqual(customMock.id, "custom-999")
        XCTAssertEqual(customMock.title, "WWDC Keynote Watch")
        XCTAssertEqual(customMock.format, .online)
        XCTAssertEqual(customMock.modality, .workshop)
        XCTAssertFalse(customMock.isFree)
        XCTAssertEqual(customMock.priceText, "R$ 99.90")
        XCTAssertTrue(customMock.isBookmarked)
        XCTAssertEqual(customMock.speakers.count, 1)
        XCTAssertEqual(customMock.speakers.first?.name, "Ana Silva")
        XCTAssertEqual(customMock.schedule.count, 1)
        XCTAssertEqual(customMock.schedule.first?.title, "Abertura")
    }
}
