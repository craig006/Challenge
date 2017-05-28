import Foundation

protocol LoggerService {
    func log(error: Error)
    func log(string: String)
}
