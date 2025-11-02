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
    private let dataClient: DataClientProtocol

    init(
        httpClient: HTTPClientProtocol,
        dataClient: DataClientProtocol
    ) {
        self.httpClient = httpClient
        self.dataClient = dataClient
    }
    
    func fetchPictures(startDate: String, endDate: String) -> Promise<[Home.Response]> {
        return httpClient.send(Home.PicturesRequest(
            startDate: startDate,
            endDate: endDate
        ))
    }
    
    func fetchFavorites() -> [Home.Response] {
        do {
            let favorites = try dataClient.fetch(entityName: "Favorite", predicate: nil, sortDescriptors: nil)

            let responses = favorites.compactMap { favorite -> Home.Response? in
                guard
                    let title = favorite.value(forKey: "title") as? String,
                    let explanation = favorite.value(forKey: "explanation") as? String,
                    let date = favorite.value(forKey: "date") as? String
                else { return nil }

                let imageURL = favorite.value(forKey: "imageUrl") as? URL

                return Home.Response(
                    title: title,
                    explanation: explanation,
                    date: date,
                    imageURL: imageURL
                )
            }

            return responses

        } catch {
            return []
        }
    }

    
    func saveFavorite(response: Home.Response) {
        do {
            let predicate = NSPredicate(format: "date == %@", response.date)
            let existing = try dataClient.fetch(entityName: "Favorite", predicate: predicate, sortDescriptors: nil)

            guard existing.isEmpty else {
                return
            }

            try dataClient.create(entityName: "Favorite") { object in
                object.setValue(response.title, forKey: "title")
                object.setValue(response.explanation, forKey: "explanation")
                object.setValue(response.date, forKey: "date")
                object.setValue(response.imageURL, forKey: "imageUrl")
            }

        } catch {
            print("❌ Erro ao salvar favorito: \(error)")
        }
    }
    
    func deleteFavorite(date: String) {
        do {
            let predicate = NSPredicate(format: "date == %@", date)
            let results = try dataClient.fetch(entityName: "Favorite", predicate: predicate, sortDescriptors: nil)

            guard let favorite = results.first else {
                return
            }

            try dataClient.delete(object: favorite)

        } catch {
            print("❌ Erro ao deletar favorito: \(error)")
        }
    }
}
