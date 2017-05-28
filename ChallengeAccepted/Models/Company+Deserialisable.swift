import Foundation
import SwiftyJSON
import CoreData

extension Company {
    convenience init(json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        name = json["name"].string ?? ""
        catchPhrase = json["catchPhrase"].string ?? ""
        bs = json["bs"].string ?? ""
    }
}
