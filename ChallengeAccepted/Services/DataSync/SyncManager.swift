import Foundation
import CoreData
import SwiftyJSON
import Alamofire

class SyncManager<Entity: NSManagedObject> {
    
    var onNewEntity: ((Entity, NSManagedObjectContext) -> ())?
    var logger = Dependencies.resolve(LoggerService.self)
    private var dataFetcher: DataFetcher
    private var resourceName: String
    private var context: NSManagedObjectContext
    private var entityInitializer: (JSON, NSManagedObjectContext) -> Entity
    private var completion: (() -> ())?

    init(resourceName: String, context: NSManagedObjectContext, entityInitializer: @escaping (JSON, NSManagedObjectContext) -> Entity, dataFetcher: DataFetcher) {
        self.resourceName = resourceName
        self.context = context
        self.resourceName = resourceName
        self.entityInitializer = entityInitializer
        self.dataFetcher = dataFetcher
    }

    func startSync(completion: @escaping () -> ()) {
        self.completion = completion
        download()
    }

    private func download() {
        dataFetcher.fetch(resource: resourceName, successCallback: sync)
    }

    private func sync(json: JSON) {
        json.arrayValue.filter(isNewEntity).forEach(insertNew)
        completion?()
    }

    private func isNewEntity(entityJson: JSON) -> Bool {
        let id = entityJson["id"].int32!
        return !context.exists(entity: Entity.self, format: "id == \(id)")
    }

    private func insertNew(entityJson: JSON) {
        let entity = entityInitializer(entityJson, context)
        onNewEntity?(entity, context)
    }
}
