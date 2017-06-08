import Foundation
import CoreData
@testable import ChallengeAccepted

class InMemoryCoreDataService: CoreDataService {
    
    override func createContainer() -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "ChellengeAccepted")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                self.logger.log(error: error)
            }
        })
        
        return container
    }
}
