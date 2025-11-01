import Foundation
import NasaNetworkInterface
import PromiseKit

protocol HomeDataProviderProtocol {
    func fetchPictureDay(date: String) -> Promise<Home.Response>
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]>
}

final class HomeDataProvider: HomeDataProviderProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchPictureDay(date: String) -> Promise<Home.Response> {
        return httpClient.send(Home.PictureDayRequest(
            date: date
        ))
    }
    
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]> {
        return httpClient.send(Home.PicturesRequest(
            startDate: startDate,
            endDate: endDate
        ))
    }
}
