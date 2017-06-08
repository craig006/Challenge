import XCTest
import CoreData
import SwiftyJSON
@testable import ChallengeAccepted

class SyncManagerTests: XCTestCase {
    
    var dataService: DataService!
    var dataFetcher: DataFetcher!
    var insertCount = 0
    var expect: XCTestExpectation!
    var syncManager: SyncManager<User>!
    
    override func setUp() {
        super.setUp()
        
        dataService = TestDependencies.resolve(DataService.self)!
        dataFetcher = TestDependencies.resolve(DataFetcher.self)!
        expect = expectation(description: "Sync manager should complete successfully")
        syncManager = SyncManager<User>(resourceName: "users", context: dataService.viewContext, entityInitializer: User.init, dataFetcher: dataFetcher)
        syncManager.onNewEntity = { _ in self.insertCount += 1 }
    }
    
    func testNoEntitiesExist() {
        merge(existingUserCount: 0)
    }
    
    func testMergeNeeded() {
        merge(existingUserCount: 5)
    }
    
    func testAllEntitiesExist() {
        merge(existingUserCount: 10)
    }
    
    func merge(existingUserCount: Int) {
        
        prepopulateUsers(take: existingUserCount, dataService: dataService)
        
        syncManager.startSync(completion: {
            XCTAssertEqual(self.insertCount, 10 - existingUserCount)
            self.expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1)
    }

    func prepopulateUsers(take: Int, dataService: DataService) {
        var json = MockDataFetcher.allUsers()
        
        for index in 0..<take {
            User(json: json[index], insertInto: dataService.viewContext)
        }
    }
}
