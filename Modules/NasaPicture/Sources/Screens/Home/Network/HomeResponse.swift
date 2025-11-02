import Foundation

extension Home {
    struct Response: Decodable {
        var title: String
        var explanation: String
        var date: String
        var imageURL: URL?

        enum CodingKeys: String, CodingKey {
            case title
            case explanation
            case date
            case imageURL = "url"
        }

        init(
            title: String,
            explanation: String,
            date: String,
            imageURL: URL?
        ) {
            self.title = title
            self.explanation = explanation
            self.date = date
            self.imageURL = imageURL
        }
    }
}
