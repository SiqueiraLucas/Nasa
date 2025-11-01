import Foundation

extension Home {
    struct Response: Decodable {
        var title: String
        var date: String
        var imageURL: URL

        enum CodingKeys: String, CodingKey {
            case title
            case date
            case imageURL = "image_url"
        }

        init(
            title: String,
            date: String,
            imageURL: URL
        ) {
            self.title = title
            self.date = date
            self.imageURL = imageURL
        }
    }
}
