import Foundation

enum AppConfig {
    static let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
    static let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "YOUR_DEMO_KEY"
    
    static let dataContainerName = "DataContainerModel"
}
