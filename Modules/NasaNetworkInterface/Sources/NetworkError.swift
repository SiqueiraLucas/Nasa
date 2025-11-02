import Foundation

public enum NetworkErrorType {
    case timeout
    case noInternetConnection
    case networkConnectionLost
    case internalError
    case unknown
    case contract
    case withValue(errorValue: Error)
    case generic(statusCode: Int)
}

public struct NetworkError: Error {
    public let underlyingError: Error
    public let type: NetworkErrorType

    public init(
        underlyingError: Error = NSError(),
        type: NetworkErrorType
    ) {
        self.underlyingError = underlyingError
        self.type = type
    }
}

public extension NetworkError {
    
    struct DisplayInfo {
        public let title: String
        public let description: String
        public let buttonTitle: String?
    }
    
    public var displayInfo: DisplayInfo {
        switch type {
        case .timeout:
            return DisplayInfo(
                title: "Tempo esgotado",
                description: "A solicitação demorou demais para responder. Por favor, tente novamente.",
                buttonTitle: "Tentar novamente"
            )
        case .noInternetConnection:
            return DisplayInfo(
                title: "Sem conexão",
                description: "Parece que você está sem internet. Verifique sua conexão e tente novamente.",
                buttonTitle: "Tentar novamente"
            )
        case .networkConnectionLost:
            return DisplayInfo(
                title: "Conexão perdida",
                description: "Sua conexão com a internet foi perdida. Tente novamente.",
                buttonTitle: "Tentar novamente"
            )
        case .internalError:
            return DisplayInfo(
                title: "Erro interno",
                description: "Ocorreu um erro inesperado no servidor. Tente novamente mais tarde.",
                buttonTitle: "Tentar novamente"
            )
        case .unknown, .withValue(_):
            return DisplayInfo(
                title: "Erro desconhecido",
                description: "Ocorreu um erro inesperado no servidor. Contate o suporte.",
                buttonTitle: nil
            )
        case .contract:
            return DisplayInfo(
                title: "Erro de contrato",
                description: "Os dados recebidos não correspondem ao esperado. Contate o suporte.",
                buttonTitle: nil
            )
        case .generic(let statusCode):
            return DisplayInfo(
                title: "Erro \(statusCode)",
                description: "Ocorreu um erro no servidor (código \(statusCode)). Tente novamente.",
                buttonTitle: "Tentar novamente"
            )
        }
    }
}
