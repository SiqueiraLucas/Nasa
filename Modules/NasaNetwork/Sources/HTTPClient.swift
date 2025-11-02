import Foundation
import PromiseKit
import LogVieweriOS
import NasaNetworkInterface

public final class HTTPClient: HTTPClientProtocol {
    public var baseURL: URL
    public var defaultHeaders: [String: String]
    public var defaultQuerys: [String : Any]
    private let timeoutInterval: TimeInterval?
    private let session: URLSession
    private var trackRequestError: Bool
    private weak var delegate: ErrorResponseDelegate?

    public init(requestInfo: RequestInfo, sessionDelegate: SessionDelegate? = nil, trackRequestError: Bool = false) {
        baseURL = requestInfo.baseURL
        defaultHeaders = requestInfo.defaultHeaders
        defaultQuerys = requestInfo.defaultQuerys
        timeoutInterval = requestInfo.timeoutInterval
        session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
        self.trackRequestError = trackRequestError
    }

    public func set(_ delegate: ErrorResponseDelegate) {
        self.delegate = delegate
    }

    public func send<R>(_ resource: R) -> Promise<R.Value> where R: HTTPRequest {
        return Promise<URLResponseInfo> { seal in
            let urlRequest = try createURLRequest(from: resource, with: timeoutInterval)
            let dataTask = session.dataTask(with: urlRequest, modelType: R.Value.self) { data, response, error in
                let responseInfo = URLResponseInfo(data: data, response: response, error: error)
                seal.fulfill(responseInfo)
            }
            dataTask.priority = resource.highPriority ? 1 : 0.5
            dataTask.resume()
        }.then { urlResponseInfo -> Promise<R.Value> in
            return try self.handleDataTask(in: resource, urlResponseInfo: urlResponseInfo)
        }
    }

    public func upload<R>(_ resource: R, uploadData: UploadData) -> Promise<R.Value> where R: HTTPRequest {
        return Promise<URLResponseInfo> { seal in
            var urlRequest = try createURLRequest(from: resource, with: timeoutInterval)
            urlRequest.setValue("multipart/form-data; boundary=\(uploadData.boundary)", forHTTPHeaderField: "Content-Type")
            let dataTask = session.uploadTask(with: urlRequest, from: uploadData.data) { data, response, error in
                let responseInfo = URLResponseInfo(data: data, response: response, error: error)
                seal.fulfill(responseInfo)
            }
            dataTask.priority = resource.highPriority ? 1 : 0.5
            dataTask.resume()
        }.then { urlResponseInfo -> Promise<R.Value> in
            return try self.handleDataTask(in: resource, urlResponseInfo: urlResponseInfo)
        }
    }

    private func createURLRequest<R>(from resource: R, with timeoutInterval: TimeInterval?) throws -> URLRequest where R: HTTPRequest {
        let baseURL = try self.baseURL(from: resource)
        var urlRequest = URLRequest(url: baseURL)
        if let timeoutInterval = timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        urlRequest.httpMethod = resource.method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders.merging(resource.headers) { _, new -> String in new }
        urlRequest.httpBody = jsonBody(from: resource)
        var mergedQueryParams = resource.queryParams
        if !defaultQuerys.isEmpty {
            mergedQueryParams.merge(defaultQuerys) { _, new in new }
        }
        
        urlRequest.url = url(urlRequest.url, withResourceQueryParams: mergedQueryParams)
        return urlRequest
    }

    private func jsonBody<R>(from resource: R) -> Data? where R: HTTPRequest {
        guard !resource.jsonBody.isEmpty,
              let data = try? JSONSerialization.data(withJSONObject: resource.jsonBody, options: JSONSerialization.WritingOptions.init(rawValue: 0)) else {
            return nil
        }
        return data
    }

    private func url(_ url: URL?, withResourceQueryParams queryParams: [String: Any]) -> URL? {
        guard let currentURL = url,
              !queryParams.isEmpty,
              var urlComponents = URLComponents(string: currentURL.absoluteString) else {
            return url
        }

        var queryItems = [URLQueryItem]()
        for tuple in queryParams {
            for value in ((tuple.value as? [Any]) ?? [tuple.value]) {
                let query = URLQueryItem(name: tuple.key,
                                         value: String(describing: value))
                queryItems.append(query)
            }
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return urlComponents.url
    }

    private func baseURL<R: HTTPRequest>(from resource: R) throws -> URL {
        let baseURL = resource.baseURL ?? self.baseURL
        guard let url = URL(string: baseURL.absoluteString + resource.path) else {
            throw NetworkError(type: .unknown)
        }
        return url
    }

    private func handleDataTask<R: HTTPRequest>(in resource: R,
                                                urlResponseInfo: URLResponseInfo) throws -> Promise<R.Value>
    {
        if let error = urlResponseInfo.error {
            let errorType = networkErrorType(from: error)
            throw NetworkError(underlyingError: error, type: errorType)
        }

        guard let data = urlResponseInfo.data else {
            let errorType = NetworkErrorType.internalError
            throw NetworkError(type: errorType)
        }

        if isErrorResponse(urlResponseInfo.response) {
            guard let responseStatusCode = statusCode(from: urlResponseInfo.response) else {
                let errorType = NetworkErrorType.internalError
                throw NetworkError(type: errorType)
            }

            if responseStatusCode == 401 {
                delegate?.didGetUnauthorized()
            }

            if let errorValue = try? resource.serializeError(data: data) as? Error {
                let errorType = NetworkErrorType.withValue(errorValue: errorValue)
                throw NetworkError(type: errorType)
            } else {
                let errorType = NetworkErrorType.generic(statusCode: responseStatusCode)
                throw NetworkError(type: errorType)
            }
        }

        do {
            let value = try resource.serialize(data: data)
            return Promise<R.Value>.value(value)
        } catch {
            let errorType = NetworkErrorType.contract
            throw NetworkError(type: errorType)
        }
    }

    private func isErrorResponse(_ response: URLResponse?) -> Bool {
        guard let responseStatusCode = statusCode(from: response) else {
            return true
        }
        return (responseStatusCode < 200 || responseStatusCode >= 400)
    }

    private func statusCode(from response: URLResponse?) -> Int? {
        return (response as? HTTPURLResponse)?.statusCode
    }

    private func networkErrorType(from error: Error?) -> NetworkErrorType {
        guard let error = error as? URLError else {
            return .unknown
        }
        switch error.code {
        case .timedOut:
            return .timeout
        case .notConnectedToInternet:
            return .noInternetConnection
        case .networkConnectionLost:
            return .networkConnectionLost
        case .cancelled:
            return .unknown
        default:
            return .generic(statusCode: error.code.rawValue)
        }
    }

    public func cancel<R>(_ resource: R) where R: HTTPRequest {
        session.getTasksWithCompletionHandler { [weak self] taskArray, _, _ in
            guard let self = self, let urlRequest = try? self.createURLRequest(from: resource, with: self.timeoutInterval) else {
                return
            }
            for task in taskArray where task.currentRequest?.url?.absoluteString == urlRequest.url?.absoluteString {
                task.cancel()
            }
        }
    }

    public func add(defaultHeader header: String, value: String) {
        defaultHeaders[header] = value
    }

    public func remove(defaultHeader header: String) {
        defaultHeaders.removeValue(forKey: header)
    }

    public func set(defaultHeaders: [String: String]) {
        self.defaultHeaders = defaultHeaders
    }
}

private struct URLResponseInfo {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

public struct RequestInfo {
    let baseURL: URL
    let timeoutInterval: TimeInterval?
    let defaultHeaders: [String: String]
    let defaultQuerys: [String : Any]

    public init(baseURL: URL, timeoutInterval: TimeInterval? = nil, defaultHeaders: [String: String] = [:], defaultQuerys: [String : Any] = [:]) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.defaultHeaders = defaultHeaders
        self.defaultQuerys = defaultQuerys
    }
}
