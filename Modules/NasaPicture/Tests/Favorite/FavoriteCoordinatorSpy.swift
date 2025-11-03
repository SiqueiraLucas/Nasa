import Foundation
@testable import NasaPicture

final class FavoriteCoordinatorSpy: FavoriteCoordinatorProtocol {
    private(set) var navigateToDetailCalled = false
    private(set) var lastPicture: HomeData.Picture?
    
    func navigateToPictureDetail(picture: HomeData.Picture) {
        navigateToDetailCalled = true
        lastPicture = picture
    }
}
