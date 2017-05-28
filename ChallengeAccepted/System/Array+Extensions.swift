import Foundation

public extension Array {
    func group<Key: Hashable>(by selectKey: (Element) -> Key) -> [Key:[Element]] {
        var result = [Key: [Element]]()
        for item in self {
            let key = selectKey(item)
            if case nil = result[key]?.append(item) {
                result[key] = [item]
            }
        }
        return result
    }
}