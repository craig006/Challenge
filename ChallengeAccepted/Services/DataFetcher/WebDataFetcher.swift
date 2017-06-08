import Foundation
import Alamofire
import SwiftyJSON

class WebDataFetcher: DataFetcher {

    private let baseUrl = URL(string: "http://jsonplaceholder.typicode.com/")!

    var logger: LoggerService
    init(logger: LoggerService) {
        self.logger = logger
    }

    func fetch(resource: String, successCallback: @escaping (JSON) -> ()) {
        let url = URL(string: resource, relativeTo: baseUrl)!
        Alamofire.request(url).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            if let jsonData = response.data {
                successCallback(JSON(jsonData))
            } else {
                if let error = response.error {
                    self.logger.log(error: error)
                }
            }
        }
    }
}
