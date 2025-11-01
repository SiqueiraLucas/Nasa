import SwiftUI

extension Home {
    enum Initializer {
        static func createView(dependencies: Dependencies) -> some View {
            let dataProvider = HomeDataProvider(httpClient: dependencies.httpClient)
            let viewModel = HomeViewModel(dataProvider: dataProvider)
            let view = HomeView(viewModel: viewModel)
            return view
        }
    }
}
