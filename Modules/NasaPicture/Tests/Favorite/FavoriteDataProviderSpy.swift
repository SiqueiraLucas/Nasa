import Foundation
import NasaNetworkInterface
@testable import NasaPicture

final class FavoriteDataProviderSpy: FavoriteDataProviderProtocol {
    var favoritesToReturn: [Home.Response] = []
    
    private(set) var fetchFavoritesCalled = false
    private(set) var saveFavoriteCalled = false
    private(set) var deleteFavoriteCalled = false
    
    private(set) var savedResponse: Home.Response?
    private(set) var deletedDate: String?
    
    func fetchFavorites() -> [Home.Response] {
        fetchFavoritesCalled = true
        return favoritesToReturn
    }
    
    func saveFavorite(response: Home.Response) {
        saveFavoriteCalled = true
        savedResponse = response
    }
    
    func deleteFavorite(date: String) {
        deleteFavoriteCalled = true
        deletedDate = date
    }
}
