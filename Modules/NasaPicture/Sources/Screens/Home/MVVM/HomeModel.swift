import Foundation

struct HomeModel: BaseModel {
    var header = HeaderData(date: Date().toString())
    let datePicker = DatePickerData()
    
    struct HeaderData {
        let title = "Nasa"
        var date: String
    }
    
    struct DatePickerData {
        let minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let maximumDate = Date()
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
