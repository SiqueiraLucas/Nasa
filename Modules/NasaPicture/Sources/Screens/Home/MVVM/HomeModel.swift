import Foundation

struct HomeModel: BaseModel {
    typealias DataType = HomeData
    var state: ModelState<HomeData> = .loading
}

struct HomeData {
    let title: String
    let date: String
    let mainPhotoUrl: URL
}
