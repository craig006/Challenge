import Foundation
import CoreData

protocol DataService {
    var viewContext: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func saveContext()
    func saveContext (context: NSManagedObjectContext)
}

