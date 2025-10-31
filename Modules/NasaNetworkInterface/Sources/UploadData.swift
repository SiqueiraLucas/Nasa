import Foundation

public struct UploadData {
    public let boundary: String
    public let data: Data

    public init(boundary: String, data: Data) {
        self.boundary = boundary
        self.data = data
    }
}
