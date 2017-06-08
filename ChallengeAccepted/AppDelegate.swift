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
        splitController.view.backgroundColor = AppColor.lightPurple
    
        
        //This is the only way of safely fixing the divider line in the navigationbar
        let coverView = UIView(frame: splitController.view.frame)
        coverView.backgroundColor = AppColor.lightPurple;
        splitController.view.addSubview(coverView);
        splitController.view.sendSubview(toBack: coverView)
        

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splitController
        window?.makeKeyAndVisible()
        
        UISearchBar.appearance().barTintColor = AppColor.purple
        UINavigationBar.appearance().barTintColor = AppColor.purple
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage.fromColor(color: AppColor.purple), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage.fromColor(color: AppColor.lightPurple)
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = AppColor.lightPurple
    
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let service = Dependencies.resolve(DataSyncService.self)!
        service.syncData()
    }

}

