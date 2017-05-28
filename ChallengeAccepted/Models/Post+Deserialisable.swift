import Foundation
import SwiftyJSON
import CoreData

extension Post {
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = json["id"].int32 ?? 0
        userId = json["userId"].int32 ?? 0
        title = json["title"].string ?? ""
        body = json["body"].string ?? ""
    }
}
