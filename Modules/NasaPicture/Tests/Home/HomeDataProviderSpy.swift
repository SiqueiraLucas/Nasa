import Foundation
import PromiseKit
import NasaNetworkInterface
@testable import NasaPicture

final class HomeDataProviderSpy: HomeDataProviderProtocol {
    var fetchPicturesCalled = false
    var saveFavoriteCalled = false
    var deleteFavoriteCalled = false
    
    var picturesResponse: [Home.Response]?
    var favoritesResponse: [Home.Response] = []
    var shouldFailFetch = false
    
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]> {
        fetchPicturesCalled = true
        
        if shouldFailFetch {
            return Promise(error: NetworkError(type: .internalError))
        }
        
        if let response = picturesResponse {
            return Promise.value(response)
        } else {
            return Promise(error: NetworkError(type: .internalError))
        }
    }
    
    func fetchFavorites() -> [Home.Response] {
        return favoritesResponse
    }
    
    func saveFavorite(response: Home.Response) {
        saveFavoriteCalled = true
    }
    
    func deleteFavorite(date: String) {
        deleteFavoriteCalled = true
    }
}
