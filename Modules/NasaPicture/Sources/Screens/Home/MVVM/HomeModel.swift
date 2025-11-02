import Foundation

struct HomeModel: BaseModel {
    let title = "Nasa"
    var date: String
    
    struct Header {
        let title: String
        let date: String
    }
    
    typealias DataType = HomeData
    var state: ModelState<HomeData> = .loading
}

struct HomeData {
    let mainPicture: MainPicture
    
    struct MainPicture {
        let headerTitle: String
        let title: String
        let description: String
        let imageUrl: URL
    }
}
