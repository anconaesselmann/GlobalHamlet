import UIKit
import XCTest

class ActivitiesTest: XCTestCase {
    var sut : Activities!
    
    override func setUp() {
        super.setUp()
        sut = Activities()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_didReceiveAPIResults() {
        /*
        let results:NSDictionary = NSDictionary(dictionary: ["response": "[{\"actor\":\"axel1\",\"action\":\"received\",\"activity_id\": 5,\"time\": \"11/19/85\"},{\"actor\":\"axel2\",\"action\":\"sent\",\"activity_id\": 9,\"time\": \"05/25/88\"}]", "errorCode": 0]) as NSDictionary
        sut.didReceiveAPIResults(results)
        XCTAssertEqual("axel1, received", sut.activities[0].displayString())
        XCTAssertEqual("axel2, sent", sut.activities[1].displayString())*/
    }
}