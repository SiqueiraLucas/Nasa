import Foundation
import SwiftUI
import Combine
import NasaNetworkInterface

final class PictureDetailViewModel: ObservableObject {
    @Published var model: PictureDetailModel
    
    private let dataProvider: PictureDetailDataProviderProtocol
    private var lastRequestedDate: String?
    
    init(
        dataProvider: PictureDetailDataProviderProtocol,
        picture: PictureDetailModel.Picture
    ) {
        self.dataProvider = dataProvider
        self.model = PictureDetailModel(picture: picture)
    }
    
    func build() {
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

        model.picture.favorite.toggle()
    }
}
