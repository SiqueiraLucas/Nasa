import SwiftUI
import NasaNetworkInterface
import NasaNetwork
import NasaPicture
import LogVieweriOS
import CoreData

@main
struct NasaApp: App {
    // MARK: - Dependencies
    private let httpClient: HTTPClientProtocol
    private let dataClient: DataClientProtocol
    private let pictureFeature: NasaPicture.Feature
    private let navigationController: UINavigationController

    init() {
        let baseURL = AppConfig.baseURL
        let defaultQuerys: [String: Any] = ["api_key": AppConfig.apiKey]
        let requestInfo = RequestInfo(baseURL: baseURL, timeoutInterval: 10, defaultQuerys: defaultQuerys)
        httpClient = HTTPClient(requestInfo: requestInfo)
        
        dataClient = DataClient(modelName: AppConfig.dataContainerName)
        
        navigationController = UINavigationController()
        
        let dependencies = NasaPicture.Dependencies(
            httpClient: httpClient,
            dataClient: dataClient,
            navigationController: navigationController
        )
        pictureFeature = NasaPicture.Feature(dependencies: dependencies)
        
        LogViewerProvider.setEnableInDebug(true)
        LogViewerProvider.setEnableInRelease(false)
    }

    var body: some Scene {
        WindowGroup {
            RootHostingController(rootView: pictureFeature.initialView(), navigationController: navigationController)
        }
    }
}

struct RootHostingController: UIViewControllerRepresentable {
    let rootView: AnyView
    let navigationController: UINavigationController

    init<V: View>(rootView: V, navigationController: UINavigationController) {
        self.rootView = AnyView(rootView)
        self.navigationController = navigationController
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let hosting = UIHostingController(rootView: rootView)
        navigationController.viewControllers = [hosting]
        let backImage = UIImage(systemName: "arrow.left")
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.navigationBar.topItem?.backButtonDisplayMode = .minimal
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
