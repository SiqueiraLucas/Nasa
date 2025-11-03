import SwiftUI

extension Home {
    enum Initializer {
        static func createView(dependencies: Dependencies) -> some View {
            let dataProvider = HomeDataProvider(
                httpClient: dependencies.httpClient,
                dataClient: dependencies.dataClient
            )
            let coordinator = HomeCoordinator(
                dependencies: dependencies
            )
            let viewModel = HomeViewModel(
                dataProvider: dataProvider,
                coordinator: coordinator
            )
            let view = HomeView(viewModel: viewModel)
            return view
        }
    }
}
