import Foundation
import NasaNetworkInterface

extension Home {
    struct PictureDayRequest: HTTPRequest {
        typealias Value = Response
        var method = HTTPMethod.get
        
        let date: String
        
        var queryParams: [String : Any] {[
            "date": date
        ]}
    }
    
    struct PicturesRequest: HTTPRequest {
        typealias Value = [Response]
        var method = HTTPMethod.get
        
        let startDate: String
        let endDate: String
        
        var queryParams: [String : Any] {[
            "api_key": "key",
            "start_date": startDate,
            "end_date": endDate
        ]}
    }
}
