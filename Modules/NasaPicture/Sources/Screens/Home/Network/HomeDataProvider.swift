import Foundation
import NasaNetworkInterface
import PromiseKit

protocol HomeDataProviderProtocol {
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]>
    func fetchFavorites() -> [Home.Response]
    func saveFavorite(response: Home.Response)
    func deleteFavorite(date: String)
}

final class HomeDataProvider: HomeDataProviderProtocol {
    private let httpClient: HTTPClientProtocol
    private let favoritesManager: FavoritesManager

    init(httpClient: HTTPClientProtocol, dataClient: DataClientProtocol) {
        self.httpClient = httpClient
        self.favoritesManager = FavoritesManager(dataClient: dataClient)
    }

    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]> {
        return httpClient.send(Home.PicturesRequest(startDate: startDate, endDate: endDate))
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
