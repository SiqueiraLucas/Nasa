import SwiftUI
import NasaNetworkInterface
import NasaNetwork
import NasaPicture
import LogVieweriOS

@main
struct NasaApp: App {
    // MARK: - Dependencies
    private let httpClient: HTTPClientProtocol
    private let pictureFeature: NasaPicture.Feature

    init() {
        // Setup HTTP Client
        let baseURL = AppConfig.baseURL
        let defaultQuerys: [String: Any] = ["api_key": AppConfig.apiKey]
        let requestInfo = RequestInfo(baseURL: baseURL, defaultQuerys: defaultQuerys)
        httpClient = HTTPClient(requestInfo: requestInfo)

        // Setup Feature
        let dependencies = NasaPicture.Dependencies(httpClient: httpClient)
        pictureFeature = NasaPicture.Feature(dependencies: dependencies)

        // LogViewer
        LogViewerProvider.setEnableInDebug(true)
        LogViewerProvider.setEnableInRelease(false)
    }

    var body: some Scene {
        WindowGroup {
            pictureFeature.initialView()
        }
    }
}
