import Foundation
import NasaNetworkInterface

final class FavoritesManager {
    private let dataClient: DataClientProtocol
    private let entityName: String = "Favorite"

    init(dataClient: DataClientProtocol) {
        self.dataClient = dataClient
    }

    func saveFavorite(_ response: Home.Response) {
        do {
            let predicate = NSPredicate(format: "date == %@", response.date)
            let existing = try dataClient.fetch(entityName: entityName, predicate: predicate, sortDescriptors: nil)

            guard existing.isEmpty else { return }

            try dataClient.create(entityName: entityName) { object in
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
            let results = try dataClient.fetch(entityName: entityName, predicate: predicate, sortDescriptors: nil)

            guard let favorite = results.first else { return }

            try dataClient.delete(object: favorite)

        } catch {
            print("❌ Erro ao deletar favorito: \(error)")
        }
    }

    func fetchFavorites() -> [Home.Response] {
        do {
            let favorites = try dataClient.fetch(entityName: entityName, predicate: nil, sortDescriptors: nil)

            return favorites.compactMap { favorite -> Home.Response? in
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
        } catch {
            print("❌ Erro ao buscar favoritos: \(error)")
            return []
        }
    }
}
