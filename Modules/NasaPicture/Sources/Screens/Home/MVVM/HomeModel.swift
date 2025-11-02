import Foundation

struct HomeModel: BaseModel {
    typealias DataType = HomeData
    var state: ModelState<HomeData> = .loading
}

struct HomeData {
    let header: Header
    let mainPicture: MainPicture
    
    struct Header {
        let title: String
        let date: String
    }
    
    struct MainPicture {
        let headerTitle: String
        let title: String
        let description: String
        let imageUrl: URL
    }
}
