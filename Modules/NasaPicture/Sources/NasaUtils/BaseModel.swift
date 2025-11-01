import Foundation

public protocol BaseModel {
    associatedtype DataType
    var state: ModelState<DataType> { get set }
}

public enum ModelState<DataType> {
    case loading
    case success(DataType)
    case error(data: Any)
}
