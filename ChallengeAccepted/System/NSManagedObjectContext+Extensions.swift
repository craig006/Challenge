import Foundation
import CoreData

extension NSManagedObjectContext {
    func fetchOne<T: NSManagedObject>(entity: T.Type, format: String) -> T? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: format, argumentArray: nil)
        fetchRequest.fetchLimit = 1
        let users = try? fetch(fetchRequest)
        return users?.first as? T
    }

    func exists<T: NSManagedObject>(entity: T.Type, format: String) -> Bool {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: format, argumentArray: nil)
        fetchRequest.fetchLimit = 1
        return (try? count(for: fetchRequest)) ?? 0 == 1
    }
}