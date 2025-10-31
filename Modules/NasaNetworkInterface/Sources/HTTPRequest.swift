import Foundation

public protocol HTTPRequest {
    associatedtype Value = Data
    associatedtype ErrorValue = Data

    var method: HTTPMethod { get }
    var path: String { get }
    var baseURL: URL? { get }
    var jsonBody: [String: Any] { get }
    var queryParams: [String: Any] { get }
    var timeoutInterval: TimeInterval? { get }
    var headers: [String: String] { get }
    var highPriority: Bool { get }
    func serialize(data: Data) throws -> Value
    func serializeError(data: Data) throws -> ErrorValue
}
