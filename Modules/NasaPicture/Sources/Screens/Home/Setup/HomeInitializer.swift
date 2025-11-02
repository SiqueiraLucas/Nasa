import SwiftUI

extension Home {
    enum Initializer {
        static func createView(dependencies: Dependencies) -> some View {
            let dataProvider = HomeDataProvider(
                httpClient: dependencies.httpClient,
                dataClient: dependencies.dataClient
            )
            let viewModel = HomeViewModel(dataProvider: dataProvider)
            let view = HomeView(viewModel: viewModel)
            return view
        }
    }
}
