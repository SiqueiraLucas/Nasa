import SwiftUI

protocol FavoriteCoordinatorProtocol {
    func navigateToPictureDetail(picture: HomeData.Picture)
}

final class FavoriteCoordinator: FavoriteCoordinatorProtocol {
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func navigateToPictureDetail(picture: HomeData.Picture) {
        let detailView = PictureDetail.Initializer.createView(
            dependencies: dependencies,
            picture: picture
        )
        
        let hosting = UIHostingController(rootView: detailView)
        hosting.modalPresentationStyle = .fullScreen
        dependencies.navigationController.pushViewController(hosting, animated: true)
    }
}
