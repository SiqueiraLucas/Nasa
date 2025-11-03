import Foundation

struct FavoriteModel {
    let title: String = "Favoritos"
    var pictures: [Picture] = []
    
    typealias Picture = HomeData.Picture
}
