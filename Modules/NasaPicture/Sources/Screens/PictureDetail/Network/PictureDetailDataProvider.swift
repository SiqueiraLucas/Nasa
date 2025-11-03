import Foundation
import NasaNetworkInterface
import PromiseKit

protocol PictureDetailDataProviderProtocol {
    func saveFavorite(response: Home.Response)
    func deleteFavorite(date: String)
}

final class PictureDetailDataProvider: PictureDetailDataProviderProtocol {
    private let dataClient: DataClientProtocol

    init(
        dataClient: DataClientProtocol
    ) {
        self.dataClient = dataClient
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
