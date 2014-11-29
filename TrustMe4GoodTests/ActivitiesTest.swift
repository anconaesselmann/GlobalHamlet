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
        /*let connection1 = [
        "name":"axel1",
        "email":"axel@gmail.com",
        "connection_id": 5,
        "can_be_messaged": true
        ]
        let connection2 = [
        "name":"axel2",
        "email":"axel2@gmail.com",
        "connection_id": 9,
        "can_be_messaged": false
        ]
        let response = [connection1, connection2]
        let results:NSDictionary = NSDictionary(dictionary: ["response": response, "errorCode": 0]) as NSDictionary*/
        let results:NSDictionary = NSDictionary(dictionary: ["response": "[{\"actor\":\"axel1\",\"action\":\"received\",\"activity_id\": 5,\"time\": \"11/19/85\"},{\"actor\":\"axel2\",\"action\":\"sent\",\"activity_id\": 9,\"time\": \"05/25/88\"}]", "errorCode": 0]) as NSDictionary
        sut.didReceiveAPIResults(results)
        XCTAssertEqual("axel1, received", sut.activities[0].displayString())
        XCTAssertEqual("axel2, sent", sut.activities[1].displayString())
    }
}