import CoreData

public protocol DataClientProtocol {
    func create(entityName: String, configure: (NSManagedObject) -> Void) throws
    func fetch(entityName: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [NSManagedObject]
    func update(object: NSManagedObject, configure: (NSManagedObject) -> Void) throws
    func delete(object: NSManagedObject) throws
}
