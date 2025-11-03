import SwiftUI

extension Favorite {
    enum Initializer {
        static func createView(dependencies: Dependencies) -> some View {
            let dataProvider = FavoriteDataProvider(
                dataClient: dependencies.dataClient
            )
            let coordinator = FavoriteCoordinator(
                dependencies: dependencies
            )
            let viewModel = FavoriteViewModel(
                dataProvider: dataProvider,
                coordinator: coordinator
            )
            let view = FavoriteView(viewModel: viewModel)
            return view
        }
    }
}
