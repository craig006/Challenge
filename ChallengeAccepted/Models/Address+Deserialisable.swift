import Foundation
import SwiftyJSON
import CoreData

extension Address {
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        street = json["street"].string ?? ""
        suite = json["suite"].string ?? ""
        city = json["city"].string ?? ""
        zipcode = json["zipcode"].string ?? ""
        geo = Geo(json: json["geo"], insertInto: context)
    }
}
