import UIKit
import NasaNetworkInterface
import NasaNetwork
import NasaPicture

final class AppBuilder: NSObject {
    // MARK: Dependencies
    private let httpClient: HTTPClientProtocol

    override init() {
        // Setup HTTPClient
        let baseURL = URL(string: "about:blank")!
        let defaultHeaders: [String : String] = [:]
        let requestInfo = RequestInfo(baseURL: baseURL, defaultHeaders: defaultHeaders)
        httpClient = HTTPClient(requestInfo: requestInfo)
        //
        super.init()
    }

    // MARK: Features
    private lazy var picture = NasaPicture.Feature(dependencies: pictureDependencies())
    private func pictureDependencies() -> NasaPicture.Dependencies {
        .init(httpClient: httpClient)
    }

    func returnInitialController() -> UIViewController {
        return picture.initialViewController() ?? UIViewController()
    }
}
