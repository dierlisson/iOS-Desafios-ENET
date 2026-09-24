import Foundation
import XCTest
@testable import RickAndMortyCharacters

/// Mock URLProtocol for intercepting URLSession requests in unit tests.
public final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    public nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data?))?
    public nonisolated(unsafe) static var requestObserver: (@Sendable (URLRequest) -> Void)?

    override public class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override public func startLoading() {
        Self.requestObserver?(request)
        guard let handler = Self.requestHandler else {
            XCTFail("MockURLProtocol requestHandler is not set.")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override public func stopLoading() {}

    public static func createMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
