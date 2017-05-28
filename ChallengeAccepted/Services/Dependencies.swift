
import Foundation
import SwinjectAutoregistration
import Swinject

let Dependencies: Resolver = Swinject.Container() { container in
    container.autoregister(DataService.self, initializer: CoreDataService.init).inObjectScope(.container)
    container.autoregister(DataSyncService.self, initializer: FullDataSyncService.init)
    container.autoregister(PostsController.self, initializer: PostsController.init(dataService:))
    container.autoregister(DetailsController.self, initializer: DetailsController.init(dataService:))
    container.autoregister(LoggerService.self, initializer: ConsoleLoggerService.init)
}