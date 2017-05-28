import Foundation
import SwiftyJSON
import CoreData

extension Photo {
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = json["id"].int32 ?? 0
        albumId = json["albumId"].int32 ?? 0
        title = json["title"].string ?? ""
        url = json["url"].string ?? ""
        thumbnailUrl = json["thumbnailUrl"].string ?? ""
    }
}
