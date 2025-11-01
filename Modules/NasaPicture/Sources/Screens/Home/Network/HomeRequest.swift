import Foundation
import NasaNetworkInterface

extension Home {
    struct Request: HTTPRequest {
        typealias Value = Response
        
        var baseURL = URL(string: "")
        var method = HTTPMethod.get
    }
}
