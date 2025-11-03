import Foundation
import NasaNetworkInterface
import PromiseKit

protocol FavoriteDataProviderProtocol {
    func fetchFavorites() -> [Home.Response]
    func saveFavorite(response: Home.Response)
    func deleteFavorite(date: String)
}

open class FavoriteDataProvider: FavoriteDataProviderProtocol {
    private let favoritesManager: FavoritesManager

    init(dataClient: DataClientProtocol) {
        self.favoritesManager = FavoritesManager(dataClient: dataClient)
    }
    
    func fetchFavorites() -> [Home.Response] {
        return favoritesManager.fetchFavorites()
    }

    func saveFavorite(response: Home.Response) {
        favoritesManager.saveFavorite(response)
    }

    func deleteFavorite(date: String) {
        favoritesManager.deleteFavorite(date: date)
    }
}
