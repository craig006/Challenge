import Foundation
import UIKit

extension UITableView {
    func selectNearestCell(indexPath: IndexPath) {
        
        if isValidIndexPath(indexPath: indexPath) {
            selectRow(at: indexPath, animated: false, scrollPosition: .none)
            delegate?.tableView?(self, didSelectRowAt: indexPath)
        
        } else {
            var newIndexPath = indexPath
            if indexPath.row > 0 {
                newIndexPath.row -= 1
            } else if indexPath.section > 0 {
                newIndexPath.section -= 1
                newIndexPath.row = numberOfRows(inSection: newIndexPath.section)
            } else {
                return
            }
            selectNearestCell(indexPath: newIndexPath)
        }
    }
    
    func isValidIndexPath(indexPath: IndexPath) -> Bool {
        return numberOfSections > indexPath.section && numberOfRows(inSection: indexPath.section) > indexPath.row
    }
}
