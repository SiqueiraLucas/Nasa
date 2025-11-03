import Foundation
import NasaNetworkInterface
import PromiseKit

protocol FavoriteDetailDataProviderProtocol {
    func saveFavorite(response: Home.Response)
    func deleteFavorite(date: String)
}

final class FavoriteDetailDataProvider: FavoriteDetailDataProviderProtocol {
    private let favoritesManager: FavoritesManager

    init(dataClient: DataClientProtocol) {
        self.favoritesManager = FavoritesManager(dataClient: dataClient)
    }

    func saveFavorite(response: Home.Response) {
        favoritesManager.saveFavorite(response)
    }

    func deleteFavorite(date: String) {
        favoritesManager.deleteFavorite(date: date)
    }
}
