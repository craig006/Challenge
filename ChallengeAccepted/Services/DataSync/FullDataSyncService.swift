import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class FullDataSyncService: DataSyncService {

    var dataService: DataService
    var dataFetcher: DataFetcher

    init(dataService: DataService, dataFetcher: DataFetcher) {
        self.dataService = dataService
        self.dataFetcher = dataFetcher
    }

    func syncData() {

        let context = dataService.newBackgroundContext()

        let userSyncManager = SyncManager<User>(resourceName: "users", context: context, entityInitializer: User.init, dataFetcher: dataFetcher)

        let postsSyncManager = SyncManager<Post>(resourceName: "posts", context: context, entityInitializer: Post.init, dataFetcher: dataFetcher)
        postsSyncManager.onNewEntity = onNew

        let albumSyncManager = SyncManager<Album>(resourceName: "albums", context: context, entityInitializer: Album.init, dataFetcher: dataFetcher)
        albumSyncManager.onNewEntity = onNew

        let photoSyncManager = SyncManager<Photo>(resourceName: "photos", context: context, entityInitializer: Photo.init, dataFetcher: dataFetcher)
        photoSyncManager.onNewEntity = onNew

        UIKit.UIApplication.shared.isNetworkActivityIndicatorVisible = true

        NetworkActivity.AddTask()

        userSyncManager.startSync {
            self.dataService.saveContext(context: context)

            //sync posts after users have synced
            postsSyncManager.startSync {
                self.dataService.saveContext(context: context)
            }

            //sync albums after users have synced
            albumSyncManager.startSync {
                self.dataService.saveContext(context: context)

                //sync photos after users and albums have synced
                photoSyncManager.startSync {
                    self.dataService.saveContext(context: context)
                    DispatchQueue.main.async {
                        NetworkActivity.RemoveTask()
                    }
                }
            }
        }
    }

    private func onNew(entity: Post, context: NSManagedObjectContext) {
        let user = context.fetchOne(entity: User.self, format: "id == \(entity.userId)")!
        user.addToPosts(entity)
    }

    private func onNew(entity: Album, context: NSManagedObjectContext) {
        let user = context.fetchOne(entity: User.self, format: "id == \(entity.userId)")!
        user.addToAlbums(entity)
    }

    private func onNew(entity: Photo, context: NSManagedObjectContext) {
        let album = context.fetchOne(entity: Album.self, format: "id == \(entity.albumId)")!
        album.addToPhotos(entity)
    }
}






