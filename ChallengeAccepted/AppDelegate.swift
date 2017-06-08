import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var dataServie: DataService = { Dependencies.resolve(DataService.self)! }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let splitController = UISplitViewController()
        let postsController = Dependencies.resolve(PostsController.self)!
        let detailController = Dependencies.resolve(DetailsController.self)!
        postsController.postPresenter = detailController

        let leftNavigationController = UINavigationController(rootViewController: postsController)
        let rightNavigationController = UINavigationController(rootViewController: detailController)
        rightNavigationController.view.backgroundColor = UIColor.white

        splitController.viewControllers = [leftNavigationController, rightNavigationController]
        splitController.preferredDisplayMode = .allVisible
        splitController.maximumPrimaryColumnWidth = 320
        splitController.minimumPrimaryColumnWidth = 320

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splitController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let service = Dependencies.resolve(DataSyncService.self)!
        service.syncData()
    }

}

