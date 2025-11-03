import Foundation
import NasaNetworkInterface
import PromiseKit

protocol HomeDataProviderProtocol {
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]>
    func fetchFavorites() -> [Home.Response]
    func saveFavorite(response: Home.Response)
    func deleteFavorite(date: String)
}

final class HomeDataProvider: FavoriteDataProvider, HomeDataProviderProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol, dataClient: DataClientProtocol) {
        self.httpClient = httpClient
        super.init(dataClient: dataClient)
    }

    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]> {
        return httpClient.send(Home.PicturesRequest(startDate: startDate, endDate: endDate))
    }
}
