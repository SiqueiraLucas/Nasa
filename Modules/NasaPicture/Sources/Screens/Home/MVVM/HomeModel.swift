import Foundation

struct HomeModel {
    let title: String
    let date: String
    let mainPhotoUrl: URL
    
    static let empty = Self(
        title: "",
        date: "",
        mainPhotoUrl: URL(string: "https://example.com/test")!
    )
}
