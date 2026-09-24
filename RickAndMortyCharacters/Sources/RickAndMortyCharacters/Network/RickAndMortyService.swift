import Foundation

/// Protocol defining the network operations for the Rick & Morty API.
public protocol RickAndMortyServiceProtocol: Sendable {
    /// Fetches a paginated list of characters, optionally filtered by name and page.
    func fetchCharacters(name: String?, page: Int?) async throws -> CharacterResponse

    /// Fetches a paginated list of characters with full filter support and configurable retries.
    func fetchCharacters(
        name: String?,
        page: Int?,
        status: RMStatus?,
        gender: RMGender?,
        maxRetries: Int
    ) async throws -> CharacterResponse

    /// Fetches a single character by ID.
    func fetchCharacter(id: Int) async throws -> RMCharacter
}

public extension RickAndMortyServiceProtocol {
    func fetchCharacters(name: String? = nil, page: Int? = 1) async throws -> CharacterResponse {
        try await fetchCharacters(name: name, page: page, status: nil, gender: nil, maxRetries: 3)
    }
}

/// Service implementation for consuming the Rick & Morty REST API using URLSession and async/await.
public final class RickAndMortyService: RickAndMortyServiceProtocol, Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder

    /// Initializes the service with a custom URLSession (defaults to .shared).
    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    /// Fetches characters with pagination and optional search filter.
    public func fetchCharacters(
        name: String? = nil,
        page: Int? = 1,
        status: RMStatus? = nil,
        gender: RMGender? = nil,
        maxRetries: Int = 3
    ) async throws -> CharacterResponse {
        guard let url = RickAndMortyEndpoint.characters(name: name, page: page, status: status, gender: gender).url else {
            throw RMNetworkError.invalidURL
        }

        do {
            return try await executeWithRetry(maxRetries: maxRetries) {
                try await self.performRequest(url: url)
            }
        } catch let error as RMNetworkError {
            // Handle 404 when searching by name returning empty results gracefully
            if case let .httpError(statusCode, _) = error, statusCode == 404, name != nil {
                return CharacterResponse.empty
            }
            throw error
        }
    }

    /// Fetches a character by their unique ID.
    public func fetchCharacter(id: Int) async throws -> RMCharacter {
        guard let url = RickAndMortyEndpoint.characterDetail(id: id).url else {
            throw RMNetworkError.invalidURL
        }

        return try await executeWithRetry(maxRetries: 3) {
            try await self.performRequest(url: url)
        }
    }

    // MARK: - Private Helpers

    /// Performs the network request and decodes the JSON payload into type T.
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost, .dnsLookupFailed:
                throw RMNetworkError.noConnection
            case .badURL, .unsupportedURL:
                throw RMNetworkError.invalidURL
            default:
                throw RMNetworkError.requestFailed(urlError.localizedDescription)
            }
        } catch {
            throw RMNetworkError.requestFailed(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RMNetworkError.requestFailed("Resposta do servidor é inválida.")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let serverMessage = parseErrorPayload(from: data)
            throw RMNetworkError.httpError(statusCode: httpResponse.statusCode, message: serverMessage)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            let detail = formatDecodingError(decodingError)
            throw RMNetworkError.decodingError(detail)
        } catch {
            throw RMNetworkError.decodingError(error.localizedDescription)
        }
    }

    /// Executes an async network operation with exponential backoff retries for transient errors.
    private func executeWithRetry<T: Sendable>(
        maxRetries: Int,
        initialDelayNanoseconds: UInt64 = 100_000_000,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        var attempts = 0
        var currentDelay = initialDelayNanoseconds

        while true {
            attempts += 1
            do {
                return try await operation()
            } catch let error as RMNetworkError {
                guard shouldRetry(error: error, currentAttempt: attempts, maxRetries: maxRetries) else {
                    throw error
                }
                try await Task.sleep(nanoseconds: currentDelay)
                currentDelay *= 2
            } catch {
                if attempts >= maxRetries {
                    throw RMNetworkError.maxRetriesExceeded(underlyingMessage: error.localizedDescription)
                }
                try await Task.sleep(nanoseconds: currentDelay)
                currentDelay *= 2
            }
        }
    }

    /// Determines if an error is transient and eligible for retry.
    private func shouldRetry(error: RMNetworkError, currentAttempt: Int, maxRetries: Int) -> Bool {
        guard currentAttempt < maxRetries else { return false }
        switch error {
        case .noConnection:
            return true
        case let .httpError(statusCode, _):
            return statusCode >= 500 || statusCode == 429
        case .requestFailed:
            return true
        case .invalidURL, .decodingError, .maxRetriesExceeded:
            return false
        }
    }

    /// Parses error message returned in JSON by the Rick & Morty API (e.g., `{"error":"There is nothing here"}`).
    private func parseErrorPayload(from data: Data) -> String? {
        struct APIErrorResponse: Decodable {
            let error: String?
        }
        return try? decoder.decode(APIErrorResponse.self, from: data).error
    }

    /// Provides detailed diagnostic info for JSON decoding failures.
    private func formatDecodingError(_ error: DecodingError) -> String {
        switch error {
        case let .typeMismatch(type, context):
            return "Tipo incompatível para '\(context.codingPath.codingPathString)': esperado \(type)"
        case let .valueNotFound(type, context):
            return "Valor nulo ou não encontrado para '\(context.codingPath.codingPathString)' de tipo \(type)"
        case let .keyNotFound(key, context):
            return "Chave '\(key.stringValue)' ausente no caminho: \(context.codingPath.codingPathString)"
        case let .dataCorrupted(context):
            return "JSON corrompido no caminho: \(context.codingPath.codingPathString)"
        @unknown default:
            return error.localizedDescription
        }
    }
}

private extension Array where Element == CodingKey {
    var codingPathString: String {
        map { $0.stringValue }.joined(separator: ".")
    }
}
