import Foundation
import SwiftyJSON

protocol DataFetcher {
    func fetch(resource: String, successCallback: @escaping (JSON) -> ())
}
