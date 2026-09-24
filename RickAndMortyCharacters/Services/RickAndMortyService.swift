import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case noConnection
    case serverError(statusCode: Int)
    case decodingError
    case notFound
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida fornecida."
        case .noConnection:
            return "Sem conexão com a internet. Verifique sua rede e tente novamente."
        case .serverError(let code):
            return "O servidor retornou um erro (código \(code))."
        case .decodingError:
            return "Falha ao processar a resposta dos dados."
        case .notFound:
            return "Nenhum personagem foi encontrado para esta busca."
        }
    }
}

public protocol RickAndMortyServiceProtocol {
    func fetchCharacters(name: String?, status: RMStatus?, gender: RMGender?, page: Int) async throws -> (characters: [RMCharacter], hasNextPage: Bool)
}

public extension RickAndMortyServiceProtocol {
    func fetchCharacters(name: String? = nil, status: RMStatus? = nil, page: Int = 1) async throws -> (characters: [RMCharacter], hasNextPage: Bool) {
        try await fetchCharacters(name: name, status: status, gender: nil, page: page)
    }
}

public final class RickAndMortyService: RickAndMortyServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchCharacters(name: String? = nil, status: RMStatus? = nil, gender: RMGender? = nil, page: Int = 1) async throws -> (characters: [RMCharacter], hasNextPage: Bool) {
        var components = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        if let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status.rawValue))
        }
        
        if let gender = gender {
            queryItems.append(URLQueryItem(name: "gender", value: gender.rawValue))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(statusCode: 500)
            }
            
            if httpResponse.statusCode == 404 {
                return (characters: [], hasNextPage: false)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(RMCharacterResponse.self, from: data)
            let hasNext = result.info.next != nil
            
            return (characters: result.results, hasNextPage: hasNext)
        } catch let error as URLError {
            if error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
                throw NetworkError.noConnection
            }
            throw NetworkError.serverError(statusCode: error.errorCode)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingError
        }
    }
}
