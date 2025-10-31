public protocol ErrorResponseDelegate: AnyObject {
    func didGetUnauthorized()
    func trackRequestError(payload: String)
}

public extension ErrorResponseDelegate {
    func trackRequestError(payload: String) {
    }
}
