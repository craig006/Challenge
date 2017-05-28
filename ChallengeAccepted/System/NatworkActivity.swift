import Foundation
import UIKit

class NetworkActivity {

    private static var taskCount = 0
    {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = taskCount > 0
        }
    }

    static func AddTask() {
        taskCount += 1
    }

    static func RemoveTask() {
        taskCount -= 1
    }
}