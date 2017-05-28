import Foundation
import CoreData
import SwiftyJSON
import Alamofire

class SyncManager<Entity: NSManagedObject> {
    var onNewEntity: ((Entity, NSManagedObjectContext) -> ())?
    var logger = Dependencies.resolve(LoggerService.self)
    private var resourceName: String
    private var context: NSManagedObjectContext
    private var entityInitializer: (JSON, NSManagedObjectContext) -> Entity
    private var completion: (() -> ())?
    private let baseUrl = URL(string: "http://jsonplaceholder.typicode.com/")!


    init(resourceName: String, context: NSManagedObjectContext, entityInitializer: @escaping (JSON, NSManagedObjectContext) -> Entity) {
        self.resourceName = resourceName
        self.context = context
        self.resourceName = resourceName
        self.entityInitializer = entityInitializer
    }

    func startSync(completion: @escaping () -> ()) {
        self.completion = completion
        download()
    }

    private func download() {
        fetch(resource: resourceName, successCallback: sync)
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

    private func fetch(resource: String, successCallback: @escaping (JSON) -> ()) {
        let url = URL(string: resource, relativeTo: baseUrl)!
        Alamofire.request(url).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            if let jsonData = response.data {
                successCallback(JSON(jsonData))
            } else {
                if let error = response.error {
                    self.logger?.log(error: error)
                }
            }
        }
    }
}
