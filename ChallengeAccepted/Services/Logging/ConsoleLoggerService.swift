import Foundation

class ConsoleLoggerService : LoggerService {
    func log(error: Error) {
        print(error)
    }

    func log(string: String) {
        print(string);
    }
}
