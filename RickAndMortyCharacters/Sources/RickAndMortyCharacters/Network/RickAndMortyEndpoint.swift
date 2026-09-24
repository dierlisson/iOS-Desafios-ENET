import Foundation

/// Helper for constructing Rick & Morty API URLs and requests.
public enum RickAndMortyEndpoint: Sendable {
    case characters(name: String? = nil, page: Int? = nil, status: RMStatus? = nil, gender: RMGender? = nil)
    case characterDetail(id: Int)

    public static let baseURLString = "https://rickandmortyapi.com/api"

    public var url: URL? {
        switch self {
        case let .characters(name, page, status, gender):
            var components = URLComponents(string: "\(Self.baseURLString)/character")
            var queryItems: [URLQueryItem] = []

            if let page {
                queryItems.append(URLQueryItem(name: "page", value: String(page)))
            }
            if let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            if let status {
                queryItems.append(URLQueryItem(name: "status", value: status.rawValue))
            }
            if let gender {
                queryItems.append(URLQueryItem(name: "gender", value: gender.rawValue))
            }

            if !queryItems.isEmpty {
                components?.queryItems = queryItems
            }
            return components?.url

        case let .characterDetail(id):
            return URL(string: "\(Self.baseURLString)/character/\(id)")
        }
    }
}
