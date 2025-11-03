import SwiftUI
import NasaNetworkInterface

public struct Dependencies {
    let httpClient: HTTPClientProtocol
    let dataClient: DataClientProtocol
    let navigationController: UINavigationController

    public init(
        httpClient: HTTPClientProtocol,
        dataClient: DataClientProtocol,
        navigationController: UINavigationController
    ) {
        self.httpClient = httpClient
        self.dataClient = dataClient
        self.navigationController = navigationController
    }
}
