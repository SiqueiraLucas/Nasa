public protocol HTTPClientLogDelegate: AnyObject {
    func logDefaultHeaders(_ defaultHeaders: [String: String])
    func logNetworkSuccess(_ log: String)
    func logNetworkError(_ log: String)
}
