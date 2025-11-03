import Foundation
@testable import NasaPicture

final class HomeCoordinatorSpy: HomeCoordinatorProtocol {    
    var navigateToPictureDetailCalled: Bool = false
    var navigateToAllFavoriteCalled: Bool = false
    
    func navigateToPictureDetail(picture: HomeData.Picture) {
        navigateToPictureDetailCalled = true
    }
    
    func navigateToAllFavorite() {
        navigateToAllFavoriteCalled = true
    }
}
