import Foundation

public extension HTTPRequest {
    var baseURL: URL? {
        return nil
    }

    var timeoutInterval: TimeInterval? {
        return nil
    }

    var headers: [String: String] {
        return [:]
    }

    var jsonBody: [String: Any] {
        return [:]
    }

    var queryParams: [String: Any] {
        return [:]
    }

    var highPriority: Bool {
        return false
    }

    var path: String {
        return ""
    }

    var method: HTTPMethod {
        return .get
    }
}

public extension HTTPRequest where Value == Data {
    func serialize(data: Data) throws -> Value {
        return data
    }
}

public extension HTTPRequest where Value: Decodable {
    func serialize(data: Data) throws -> Value {
        return try JSONDecoder().decode(Value.self, from: data)
    }
}

public extension HTTPRequest where ErrorValue: Decodable {
    func serializeError(data: Data) throws -> ErrorValue {
        return try JSONDecoder().decode(ErrorValue.self, from: data)
    }
}

public extension HTTPRequest where Value == Void {
    func serialize(data: Data) throws -> Value {
        return ()
    }
}

extension Swift.Error {
    var httpCode: Int {
        return (self as NSError).code
    }
}
