import Foundation
import SwiftyJSON
import CoreData

extension User  {
    @discardableResult
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = json["id"].int32 ?? 0
        name = json["name"].string ?? ""
        username = json["username"].string ?? ""
        email = json["email"].string ?? ""
        phone = json["phone"].string ?? ""
        website = json["website"].string ?? ""
        address = Address(json: json["address"], insertInto: context)
        company = Company(json: json["company"], insertInto: context)
    }
}
