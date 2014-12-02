import UIKit
import XCTest

class ConnectionsTest: XCTestCase {
    var sut : Connections!
    
    override func setUp() {
        super.setUp()
        sut = Connections()
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
        let results:NSDictionary = NSDictionary(dictionary: ["response": "[{\"name\":\"axel1\",\"email\":\"axel@gmail.com\",\"connection_id\": 5,\"can_be_messaged\": true},{\"name\":\"axel2\",\"email\":\"axel2@gmail.com\",\"connection_id\": 9,\"can_be_messaged\": false}]", "errorCode": 0]) as NSDictionary
        sut.didReceiveAPIResults(results)
        XCTAssertEqual("axel1, axel@gmail.com", sut.connections[0].name + ", " + sut.connections[0].email)
        XCTAssertEqual("axel2, axel2@gmail.com", sut.connections[1].name + ", " + sut.connections[1].email)
    }
}

class Mock_Delegate_11_20_14: UpdateDelegateProtocol {
    func updateDelegate() {
        
    }
}