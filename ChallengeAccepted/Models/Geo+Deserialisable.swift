import Foundation
import SwiftyJSON
import CoreData

extension Geo {
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        if let parsedLat = Double(json["lat"].string!) {
            lat = parsedLat
        }
        if let parsedLng = Double(json["lng"].string!) {
            lng = parsedLng
        }
    }
}
