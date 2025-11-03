import Foundation
import NasaNetworkInterface
import PromiseKit
@testable import NasaPicture

final class HomeDataProviderSpy: HomeDataProviderProtocol {
    var picturesResponse: [NasaPicture.Home.Response]?
    var favoritesResponse: [NasaPicture.Home.Response]?

    var fetchPicturesCalled: Bool = false
    var fetchFavoritesCalled: Bool = false
    var saveFavoriteCalled: Bool = false
    var deleteFavoriteCalled: Bool = false
    
    func fetchPictures(startDate: String, endDate: String) -> PromiseKit.Promise<[NasaPicture.Home.Response]> {
        fetchPicturesCalled = true
        
        return PromiseKit.Promise<[NasaPicture.Home.Response]>.init { resolver in
            guard let picturesResponse = picturesResponse else {
                return resolver.reject(NetworkError(type: .internalError))
            }
            resolver.fulfill(picturesResponse)
        }
    }
    
    func fetchFavorites() -> [NasaPicture.Home.Response] {
        fetchFavoritesCalled = true
        return favoritesResponse ?? []
    }
    
    func saveFavorite(response: NasaPicture.Home.Response) {
        saveFavoriteCalled = true
    }
    
    func deleteFavorite(date: String) {
        deleteFavoriteCalled = true
    }
    
}
