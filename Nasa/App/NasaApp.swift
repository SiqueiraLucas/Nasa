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
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let requestInfo = RequestInfo(baseURL: baseURL, defaultHeaders: [:])
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
