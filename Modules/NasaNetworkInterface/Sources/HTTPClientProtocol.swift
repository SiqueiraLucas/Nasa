import Foundation
import PromiseKit

public protocol HTTPClientProtocol: AnyObject {
    var baseURL: URL { get }
    var defaultHeaders: [String: String] { get }
    var defaultQuerys: [String: Any] { get }
    func send<R>(_ resource: R) -> Promise<R.Value> where R: HTTPRequest
    func upload<R>(_ resource: R, uploadData: UploadData) -> Promise<R.Value> where R: HTTPRequest
    func cancel<R>(_ resource: R) where R: HTTPRequest
    func add(defaultHeader header: String, value: String)
    func remove(defaultHeader header: String)
    func set(defaultHeaders: [String: String])
}

public enum Header {
    public static let authorization = "Authorization"
}
