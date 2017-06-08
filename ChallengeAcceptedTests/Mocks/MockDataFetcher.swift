import Foundation
import SwiftyJSON
@testable import ChallengeAccepted

class MockDataFetcher: DataFetcher {

    func fetch(resource: String, successCallback: @escaping (JSON) -> ()) {
        switch(resource) {
        case "users":
            return successCallback(MockDataFetcher.allUsers())
        case "albums":
            return successCallback(MockDataFetcher.allAlbums())
        case "posts":
            return successCallback(MockDataFetcher.allPosts())
        case "photos":
            return successCallback(MockDataFetcher.allPhotos())
        default:
            return
        }
    }

    static func allUsers() -> JSON {
        return loadJson(fromFile: "Users")
    }
    
    static func allAlbums() -> JSON {
        return loadJson(fromFile: "Albums")
    }
    
    static func allPosts() -> JSON {
        return loadJson(fromFile: "Posts")
    }
    
    static func allPhotos() -> JSON {
        return loadJson(fromFile: "Photos")
    }
    
    static func loadJson(fromFile: String) -> JSON {
        let path = Bundle(for: MockDataFetcher.self).path(forResource: fromFile, ofType: "json")!
        let jsonString = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        return JSON(parseJSON: jsonString as String)
    }
}
