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
    
    struct Response: Decodable {
        var title: String
        var explanation: String
        var date: String
        var imageHDUrl: URL?
        var imageURL: URL?

        enum CodingKeys: String, CodingKey {
            case title
            case explanation
            case date
            case imageHDUrl = "hdurl"
            case imageURL = "url"
        }

        init(
            title: String,
            explanation: String,
            date: String,
            imageHDUrl: URL?,
            imageURL: URL?
        ) {
            self.title = title
            self.explanation = explanation
            self.date = date
            self.imageHDUrl = imageHDUrl
            self.imageURL = imageURL
        }
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

                let imageHDUrl = favorite.value(forKey: "imageHDUrl") as? URL
                let imageURL = favorite.value(forKey: "imageURL") as? URL

                return Home.Response(
                    title: title,
                    explanation: explanation,
                    date: date,
                    imageHDUrl: imageHDUrl,
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
                object.setValue(response.imageHDUrl, forKey: "imageHDUrl")
                object.setValue(response.imageURL, forKey: "imageURL")
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
                print("⚠️ Nenhum favorito encontrado com a data \(date).")
                return
            }

            try dataClient.delete(object: favorite)
            print("🗑️ Favorito removido: \(date)")

        } catch {
            print("❌ Erro ao deletar favorito: \(error)")
        }
    }
}
