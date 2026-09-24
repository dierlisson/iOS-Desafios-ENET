import Foundation

/// Defines all network and decoding error states handled by RickAndMortyService.
public enum RMNetworkError: Error, LocalizedError, Equatable, Sendable {
    case invalidURL
    case noConnection
    case httpError(statusCode: Int, message: String?)
    case decodingError(String)
    case requestFailed(String)
    case maxRetriesExceeded(underlyingMessage: String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "A URL solicitada é inválida."
        case .noConnection:
            return "Sem conexão com a internet. Verifique sua rede e tente novamente."
        case let .httpError(statusCode, message):
            if let message, !message.isEmpty {
                return "Erro HTTP \(statusCode): \(message)"
            }
            return "Erro HTTP no servidor (código: \(statusCode))."
        case let .decodingError(detail):
            return "Falha ao decodificar resposta da API: \(detail)"
        case let .requestFailed(message):
            return "Falha na requisição: \(message)"
        case let .maxRetriesExceeded(underlyingMessage):
            return "Limite máximo de tentativas excedido. (\(underlyingMessage))"
        }
    }
}
