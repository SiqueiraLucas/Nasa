import Foundation
import NasaNetworkInterface
@testable import NasaPicture

final class PictureDetailDataProviderSpy: PictureDetailDataProviderProtocol {
    var saveFavoriteCalled: Bool = false
    var deleteFavoriteCalled: Bool = false
    
    func saveFavorite(response: NasaPicture.Home.Response) {
        saveFavoriteCalled = true
    }
    
    func deleteFavorite(date: String) {
        deleteFavoriteCalled = true
    }
}
