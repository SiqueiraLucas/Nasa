import Foundation
import NasaNetworkInterface
import PromiseKit

protocol HomeDataProviderProtocol {
    func fetch() -> Promise<Home.Response>
}

final class HomeDataProvider: HomeDataProviderProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetch() -> Promise<Home.Response> {
        return httpClient.send(Home.Request())
    }
}
