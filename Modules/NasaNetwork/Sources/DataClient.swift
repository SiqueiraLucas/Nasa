import CoreData
import NasaNetworkInterface

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
    }
    
    public func delete(object: NSManagedObject) throws {
        context.delete(object)
        try context.save()
    }
}
