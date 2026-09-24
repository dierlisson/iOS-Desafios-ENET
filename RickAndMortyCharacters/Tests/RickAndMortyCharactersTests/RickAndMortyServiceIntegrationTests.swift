import XCTest
@testable import RickAndMortyCharacters

final class RickAndMortyServiceIntegrationTests: XCTestCase {
    private var sut: RickAndMortyService!

    override func setUp() {
        super.setUp()
        sut = RickAndMortyService(session: .shared)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testLiveFetchFirstPageCharacters() async throws {
        let response = try await sut.fetchCharacters(name: nil, page: 1)

        XCTAssertGreaterThan(response.info.count, 0)
        XCTAssertGreaterThan(response.info.pages, 0)
        XCTAssertFalse(response.results.isEmpty)

        let firstCharacter = response.results[0]
        XCTAssertEqual(firstCharacter.id, 1)
        XCTAssertEqual(firstCharacter.name, "Rick Sanchez")
        XCTAssertEqual(firstCharacter.status, .alive)
        XCTAssertEqual(firstCharacter.species, .human)
    }

    func testLiveSearchByNameRick() async throws {
        let response = try await sut.fetchCharacters(name: "rick", page: 1)

        XCTAssertGreaterThan(response.info.count, 0)
        XCTAssertFalse(response.results.isEmpty)
        for character in response.results {
            XCTAssertTrue(character.name.localizedCaseInsensitiveContains("rick"))
        }
    }

    func testLivePaginationPage2() async throws {
        let responsePage1 = try await sut.fetchCharacters(name: nil, page: 1)
        let responsePage2 = try await sut.fetchCharacters(name: nil, page: 2)

        XCTAssertFalse(responsePage1.results.isEmpty)
        XCTAssertFalse(responsePage2.results.isEmpty)
        XCTAssertNotEqual(responsePage1.results.first?.id, responsePage2.results.first?.id)
    }

    func testLiveFetchCharacterById() async throws {
        let character = try await sut.fetchCharacter(id: 1)

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, .alive)
        XCTAssertEqual(character.species, .human)
        XCTAssertFalse(character.image.isEmpty)
    }

    func testLiveInvalidSearchReturnsEmpty() async throws {
        let response = try await sut.fetchCharacters(name: "xyznonexistentcharacter9999", page: 1)

        XCTAssertEqual(response.results.count, 0)
        XCTAssertEqual(response.info.count, 0)
    }
}
