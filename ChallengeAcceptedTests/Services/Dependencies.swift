import Foundation
import SwinjectAutoregistration
import Swinject
@testable import ChallengeAccepted

let TestDependencies: Resolver = Swinject.Container() { container in
    container.autoregister(DataService.self, initializer: InMemoryCoreDataService.init)
    container.autoregister(DataSyncService.self, initializer: FullDataSyncService.init)
    container.autoregister(PostsController.self, initializer: PostsController.init(dataService:))
    container.autoregister(DetailsController.self, initializer: DetailsController.init(dataService:))
    container.autoregister(LoggerService.self, initializer: ConsoleLoggerService.init)
    container.autoregister(DataFetcher.self, initializer: MockDataFetcher.init)
}
