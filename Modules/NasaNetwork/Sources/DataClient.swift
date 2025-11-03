import CoreData
import NasaNetworkInterface
import LogVieweriOS

public class DataClient: DataClientProtocol {
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    public init(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ Falha ao carregar modelo \(modelName)")
        }
        
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Falha ao carregar persistent store: \(error)")
            }
        }
    }
    
    public func create(entityName: String, configure: (NSManagedObject) -> Void) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw NSError(domain: "InvalidEntity", code: 0, userInfo: [NSLocalizedDescriptionKey: "Entity \(entityName) not found"])
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        configure(object)
        try context.save()
        
        log(entityName: entityName, action: "Create", objects: [object])
    }
    
    public func fetch(entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try context.fetch(request)
    }
    
    public func update(object: NSManagedObject, configure: (NSManagedObject) -> Void) throws {
        configure(object)
        try context.save()
        
        let entityName = object.entity.name ?? "UnknownEntity"
        log(entityName: entityName, action: "Update", objects: [object])
    }
    
    public func delete(object: NSManagedObject) throws {
        let entityName = object.entity.name ?? "UnknownEntity"
        log(entityName: entityName, action: "Delete", objects: [object])
        
        context.delete(object)
        try context.save()
    }
    
    private func log(entityName: String, action: String, objects: [NSManagedObject]) {
        let jsonData = convertObjectsToJSON(objects)
        LogViewerProvider.recordCustom(
            title: "COREDATA",
            payload: "\(action) \(entityName)",
            data: jsonData
        )
    }
    
    private func convertObjectsToJSON(_ objects: [NSManagedObject]) -> Data? {
        let jsonReadyObjects = objects.map { object -> [String: Any] in
            let dict = object.dictionaryWithValues(forKeys: Array(object.entity.attributesByName.keys))
            return dict.mapValues { value in
                switch value {
                case let url as NSURL:
                    return url.absoluteString ?? ""
                case let date as NSDate:
                    return ISO8601DateFormatter().string(from: date as Date)
                case let data as NSData:
                    return (data as Data).base64EncodedString()
                case let uuid as NSUUID:
                    return uuid.uuidString
                default:
                    return value
                }
            }
        }
        
        return try? JSONSerialization.data(withJSONObject: jsonReadyObjects, options: .prettyPrinted)
    }
}
