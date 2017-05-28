import Foundation
import UIKit

class RemoteImage {

    class DataCache {
        var data: Data
        init(data: Data) {
            self.data = data
        }
    }

    static var cache = NSCache<NSString, DataCache>()

    private var currentTask: URLSessionDataTask?

    func fetch(url: URL, imageCallBack: @escaping (UIImage?) -> ()) {

        if let currentTask = currentTask {
            currentTask.cancel()
        }

        if let cache = RemoteImage.cache.object(forKey: NSString(string: url.absoluteString)) {
            imageCallBack(UIImage(data: cache.data))
            return
        }

        NetworkActivity.AddTask()
        currentTask = URLSession.shared.dataTask(with: url) { (data, res, error) in

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    NetworkActivity.RemoveTask()
                }
                return
            }

            RemoteImage.cache.setObject(DataCache(data: data), forKey: NSString(string: url.absoluteString))

            DispatchQueue.main.async {
                NetworkActivity.RemoveTask()
                imageCallBack(UIImage(data: data))
            }
        }

        currentTask!.resume()
    }
}
