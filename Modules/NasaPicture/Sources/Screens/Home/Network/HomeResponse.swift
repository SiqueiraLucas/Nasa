import Foundation

extension Home {
    struct Response: Decodable {
        var title: String
        var explanation: String
        var date: String
        var imageHDUrl: URL?
        var imageURL: URL?

        enum CodingKeys: String, CodingKey {
            case title
            case explanation
            case date
            case imageHDUrl = "hdurl"
            case imageURL = "url"
        }

        init(
            title: String,
            explanation: String,
            date: String,
            imageHDUrl: URL?,
            imageURL: URL?
        ) {
            self.title = title
            self.explanation = explanation
            self.date = date
            self.imageHDUrl = imageHDUrl
            self.imageURL = imageURL
        }
    }
}
