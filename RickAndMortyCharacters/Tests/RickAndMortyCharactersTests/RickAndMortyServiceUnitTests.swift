import XCTest
@testable import RickAndMortyCharacters

final class RickAndMortyServiceUnitTests: XCTestCase {
    private var sut: RickAndMortyService!
    private var mockSession: URLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLProtocol.createMockSession()
        sut = RickAndMortyService(session: mockSession)
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.requestObserver = nil
        sut = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchCharactersURLQueryParams() async throws {
        nonisolated(unsafe) var capturedURL: URL?
        MockURLProtocol.requestObserver = { request in
            capturedURL = request.url
        }

        MockURLProtocol.requestHandler = { request in
            let json = """
            {
                "info": {"count": 1, "pages": 1, "next": null, "prev": null},
                "results": []
            }
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }

        let response = try await sut.fetchCharacters(name: "Morty", page: 3, status: .alive, gender: .male, maxRetries: 1)

        XCTAssertNotNil(capturedURL)
        let components = URLComponents(url: capturedURL!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "name" })?.value, "Morty")
        XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "page" })?.value, "3")
        XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "status" })?.value, "Alive")
        XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "gender" })?.value, "Male")
        XCTAssertTrue(response.results.isEmpty)
    }

    func testFetchCharacters404SearchResultFallback() async throws {
        MockURLProtocol.requestHandler = { request in
            let errorJson = "{\"error\": \"There is nothing here\"}".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, errorJson)
        }

        let response = try await sut.fetchCharacters(name: "UnknownCharacter123", page: 1, maxRetries: 1)
        XCTAssertEqual(response.results.count, 0)
        XCTAssertEqual(response.info.count, 0)
    }

    func testFetchCharacters500ServerErrorHttpError() async {
        MockURLProtocol.requestHandler = { request in
            let errorJson = "{\"error\": \"Internal Server Error\"}".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, errorJson)
        }

        do {
            _ = try await sut.fetchCharacters(name: nil, page: 1, maxRetries: 1)
            XCTFail("Expected HTTP 500 error to be thrown")
        } catch let error as RMNetworkError {
            if case let .httpError(statusCode, message) = error {
                XCTAssertEqual(statusCode, 500)
                XCTAssertEqual(message, "Internal Server Error")
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchCharactersNoConnectionError() async {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            _ = try await sut.fetchCharacters(name: nil, page: 1, maxRetries: 1)
            XCTFail("Expected noConnection error")
        } catch let error as RMNetworkError {
            XCTAssertEqual(error, .noConnection)
            XCTAssertNotNil(error.errorDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchCharactersDecodingError() async {
        MockURLProtocol.requestHandler = { request in
            let invalidJson = "{\"info\": \"invalid_type\"}".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJson)
        }

        do {
            _ = try await sut.fetchCharacters(name: nil, page: 1, maxRetries: 1)
            XCTFail("Expected decoding error")
        } catch let error as RMNetworkError {
            if case let .decodingError(detail) = error {
                XCTAssertFalse(detail.isEmpty)
            } else {
                XCTFail("Expected decodingError case")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRetryMechanismSucceedsOnSecondAttempt() async throws {
        nonisolated(unsafe) var attempts = 0
        MockURLProtocol.requestHandler = { request in
            attempts += 1
            if attempts == 1 {
                let response = HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!
                return (response, Data())
            } else {
                let json = """
                {
                    "info": {"count": 1, "pages": 1, "next": null, "prev": null},
                    "results": []
                }
                """.data(using: .utf8)!
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, json)
            }
        }

        let response = try await sut.fetchCharacters(name: nil, page: 1, status: nil, gender: nil, maxRetries: 3)
        XCTAssertEqual(attempts, 2)
        XCTAssertEqual(response.info.count, 1)
    }
}
