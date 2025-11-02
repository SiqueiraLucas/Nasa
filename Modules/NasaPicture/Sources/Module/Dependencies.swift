import NasaNetworkInterface

public struct Dependencies {
    let httpClient: HTTPClientProtocol
    let dataClient: DataClientProtocol

    public init(
        httpClient: HTTPClientProtocol,
        dataClient: DataClientProtocol
    ) {
        self.httpClient = httpClient
        self.dataClient = dataClient
    }
}
