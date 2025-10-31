import NasaNetworkInterface

public struct Dependencies {
    let httpClient: HTTPClientProtocol

    public init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
}
