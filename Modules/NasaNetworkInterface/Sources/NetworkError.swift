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
