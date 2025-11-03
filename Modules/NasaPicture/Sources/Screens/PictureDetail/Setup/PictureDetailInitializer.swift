import SwiftUI

extension PictureDetail {
    enum Initializer {
        static func createView(dependencies: Dependencies, picture: PictureDetailModel.Picture) -> some View {
            let dataProvider = PictureDetailDataProvider(
                dataClient: dependencies.dataClient
            )
            let viewModel = PictureDetailViewModel(dataProvider: dataProvider, picture: picture)
            let view = PictureDetailView(viewModel: viewModel)
            return view
        }
    }
}
