import Foundation
import CoreData

extension NSFetchedResultsController {
    @discardableResult
    func safePerformFetch() -> Bool {
        do {
            try performFetch()
        } catch {
            let logger = Dependencies.resolve(LoggerService.self)!
            logger.log(error: error)
            return false
        }
        return true
    }
}