import XCTest
@testable import RickAndMortyCharacters

final class ModelTests: XCTestCase {

    func testRMStatusDecoding() throws {
        let jsonAlive = "\"Alive\"".data(using: .utf8)!
        let jsonDead = "\"Dead\"".data(using: .utf8)!
        let jsonUnknown = "\"unknown\"".data(using: .utf8)!
        let jsonNovel = "\"Zombie\"".data(using: .utf8)!

        let statusAlive = try JSONDecoder().decode(RMStatus.self, from: jsonAlive)
        let statusDead = try JSONDecoder().decode(RMStatus.self, from: jsonDead)
        let statusUnknown = try JSONDecoder().decode(RMStatus.self, from: jsonUnknown)
        let statusFallback = try JSONDecoder().decode(RMStatus.self, from: jsonNovel)

        XCTAssertEqual(statusAlive, .alive)
        XCTAssertEqual(statusDead, .dead)
        XCTAssertEqual(statusUnknown, .unknown)
        XCTAssertEqual(statusFallback, .unknown)
    }

    func testRMGenderDecoding() throws {
        let jsonFemale = "\"Female\"".data(using: .utf8)!
        let jsonMale = "\"Male\"".data(using: .utf8)!
        let jsonGenderless = "\"Genderless\"".data(using: .utf8)!
        let jsonUnknown = "\"unknown\"".data(using: .utf8)!
        let jsonFallback = "\"Other\"".data(using: .utf8)!

        XCTAssertEqual(try JSONDecoder().decode(RMGender.self, from: jsonFemale), .female)
        XCTAssertEqual(try JSONDecoder().decode(RMGender.self, from: jsonMale), .male)
        XCTAssertEqual(try JSONDecoder().decode(RMGender.self, from: jsonGenderless), .genderless)
        XCTAssertEqual(try JSONDecoder().decode(RMGender.self, from: jsonUnknown), .unknown)
        XCTAssertEqual(try JSONDecoder().decode(RMGender.self, from: jsonFallback), .unknown)
    }

    func testRMSpeciesDecodingAndLiterals() throws {
        let jsonHuman = "\"Human\"".data(using: .utf8)!
        let jsonAlien = "\"Alien\"".data(using: .utf8)!
        let jsonCustom = "\"Cyborg Gazorpazorp\"".data(using: .utf8)!

        let speciesHuman = try JSONDecoder().decode(RMSpecies.self, from: jsonHuman)
        let speciesAlien = try JSONDecoder().decode(RMSpecies.self, from: jsonAlien)
        let speciesCustom = try JSONDecoder().decode(RMSpecies.self, from: jsonCustom)

        XCTAssertEqual(speciesHuman, .human)
        XCTAssertEqual(speciesAlien, .alien)
        XCTAssertEqual(speciesCustom.rawValue, "Cyborg Gazorpazorp")
        XCTAssertEqual(speciesCustom.description, "Cyborg Gazorpazorp")
    }

    func testCharacterDecodingFromJSON() throws {
        let jsonString = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let character = try JSONDecoder().decode(RMCharacter.self, from: data)

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, .alive)
        XCTAssertEqual(character.species, .human)
        XCTAssertEqual(character.gender, .male)
        XCTAssertEqual(character.origin.name, "Earth (C-137)")
        XCTAssertEqual(character.location.name, "Citadel of Ricks")
        XCTAssertEqual(character.episode.count, 1)
    }
}
