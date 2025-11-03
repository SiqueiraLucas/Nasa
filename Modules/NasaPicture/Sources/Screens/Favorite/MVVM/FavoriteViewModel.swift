import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

final class FavoriteViewModel: ObservableObject {
    @Published var model: FavoriteModel = FavoriteModel()
    
    private let dataProvider: FavoriteDataProviderProtocol
    private let coordinator: FavoriteCoordinatorProtocol
    
    init(
        dataProvider: FavoriteDataProviderProtocol,
        coordinator: FavoriteCoordinatorProtocol
    ) {
        self.dataProvider = dataProvider
        self.coordinator = coordinator
    }
    
    func build() {
        let favorites = dataProvider.fetchFavorites()
        let favoritesData = getFavoritesData(from: favorites)
        model.pictures = favoritesData
    }
    
    private func getFavoritesData(from favorites: [Home.Response]) -> [FavoriteModel.Picture] {
        if favorites.isEmpty {
            return []
        }
        
        return favorites.map {
            FavoriteModel.Picture(
                date: $0.date,
                title: $0.date,
                description: $0.explanation,
                imageUrl: $0.imageURL ?? URL(string: "https://picsum.photos/300/200")!,
                favorite: true
            )
        }
    }
    
    func didTouchFavoriteButton(picture: HomeData.Picture) {
        if picture.favorite {
            dataProvider.deleteFavorite(date: picture.date)
        } else {
            dataProvider.saveFavorite(response: Home.Response(
                title: picture.title,
                explanation: picture.description,
                date: picture.date,
                imageURL: picture.imageUrl
            ))
        }

        let favorites = dataProvider.fetchFavorites()
        let newFavoritesList = getFavoritesData(from: favorites)

        model.pictures = newFavoritesList
    }
    
    func didTouchPicture(_ picture: HomeData.Picture) {
        coordinator.navigateToPictureDetail(picture: picture)
    }
}
