import Foundation
import CoreData

class CoreDataService: DataService {

    var logger: LoggerService
    
    init(logger: LoggerService) {
        self.logger = logger
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    private var _persistentContainer: NSPersistentContainer?
    
    var persistentContainer: NSPersistentContainer
    {
        get {
            
            if _persistentContainer == nil {
                _persistentContainer = createContainer()
            }
            
            return _persistentContainer!
        }
    }
    

    var viewContext: NSManagedObjectContext
    {
        return persistentContainer.viewContext
    }
    
    var persistentStoreDescription: NSPersistentStoreDescription? {
        return nil
    }

    func newBackgroundContext() -> NSManagedObjectContext
    {
        return persistentContainer.newBackgroundContext()
    }

    func saveContext () {
        saveContext(context: viewContext)
    }

    func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.log(error: error)
            }
        }
    }
    
    func createContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ChellengeAccepted")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                self.logger.log(error: error)
            }
        })
        return container

    }
}



