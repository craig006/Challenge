import XCTest
import CoreData
import SwiftyJSON
@testable import ChallengeAccepted

class ModelDeserializationTests: XCTestCase {
    
    var dataService: DataService!
    var dataFetcher: DataFetcher!
    var insertCount = 0
    var expect: XCTestExpectation!
    var syncManager: SyncManager<User>!
    
    override func setUp() {
        super.setUp()
        dataService = TestDependencies.resolve(DataService.self)!
    }
    
    func testDeserializeUser() {
        var json = MockDataFetcher.allUsers()[0]
        
        let user = User(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(user.id, json["id"].int32Value)
        XCTAssertEqual(user.name, json["name"].stringValue)
        XCTAssertEqual(user.username, json["username"].stringValue)
        XCTAssertEqual(user.email, json["email"].stringValue)
        XCTAssertEqual(user.phone, json["phone"].stringValue)
        XCTAssertEqual(user.website, json["website"].stringValue)
        
        XCTAssertNotNil(user.address)
        XCTAssertNotNil(user.address?.geo)
        XCTAssertNotNil(user.company)
    }
    
    func testDeserializeAddress() {
        var json = MockDataFetcher.allUsers()[0]["address"]
        
        let address = Address(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(address.city, json["city"].stringValue)
        XCTAssertEqual(address.street, json["street"].stringValue)
        XCTAssertEqual(address.suite, json["suite"].stringValue)
        XCTAssertEqual(address.zipcode, json["zipcode"].stringValue)
        
        XCTAssertNotNil(address.geo)
    }
    
    func testDeserializeGeo() {
        var json = MockDataFetcher.allUsers()[0]["address"]["geo"]
        
        let geo = Geo(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(geo.lat, Double(json["lat"].string!))
        XCTAssertEqual(geo.lng, Double(json["lng"].string!))
    }
    
    func testDeserializePhoto() {
        var json = MockDataFetcher.allPhotos()[0]
        
        let photo = Photo(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(photo.id, json["id"].int32Value)
        XCTAssertEqual(photo.albumId, json["albumId"].int32Value)
        XCTAssertEqual(photo.title, json["title"].stringValue)
        XCTAssertEqual(photo.url, json["url"].stringValue)
        XCTAssertEqual(photo.thumbnailUrl, json["thumbnailUrl"].stringValue)
    }
    
    func testDeserializePost() {
        var json = MockDataFetcher.allPosts()[0]
        
        let post = Post(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(post.id, json["id"].int32Value)
        XCTAssertEqual(post.userId, json["userId"].int32Value)
        XCTAssertEqual(post.title, json["title"].stringValue)
        XCTAssertEqual(post.body, json["body"].stringValue)
    }
    
    func testDeserializeAlbum() {
        var json = MockDataFetcher.allAlbums()[0]
        
        let album = Album(json: json, insertInto: dataService.viewContext)
        
        XCTAssertEqual(album.id, json["id"].int32Value)
        XCTAssertEqual(album.userId, json["userId"].int32Value)
        XCTAssertEqual(album.title, json["title"].stringValue)
    }



}
