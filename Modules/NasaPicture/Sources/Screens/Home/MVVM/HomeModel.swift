import Foundation

struct HomeModel: BaseModel {
    var header = HeaderData(date: "2025-10-01")
    let datePicker = DatePickerData()
    
    struct HeaderData {
        let title = "Nasa"
        var date: String
    }
    
    struct DatePickerData {
        let minimumDate = "2024-10-01".toDate()
        let maximumDate = "2025-10-01".toDate()
    }
    
    typealias DataType = HomeData
    var state: ModelState<HomeData> = .loading
}

struct HomeData {
    var mainPicture: MainPicture
    var favorites: PictureList?
    var gridPicture: PictureList
    
    struct MainPicture {
        let headerTitle: String
        let picture: Picture
    }
    
    struct PictureList {
        let headerTitle: String
        let buttonTitle: String?
        var pictures: [Picture]
    }
    
    struct Picture {
        let date: String
        let title: String
        let description: String
        let imageUrl: URL
        var favorite: Bool
    }
}
