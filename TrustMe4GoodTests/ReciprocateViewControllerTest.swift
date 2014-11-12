import UIKit
import XCTest

class ReciprocateViewControllerTest: XCTestCase {
    var sut : ReciprocateViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("ReciprocateViewController") as ReciprocateViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*func test_sendCode() {
        let destination = Mock_DiViewController()
        let web = Web_Mock()
        web.urlCallResult = [
            "errorCode": 0,
            "response": true]
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.sendCode(123, code: "code345")
        
        XCTAssertEqual("test.dev/connection/reciprocate", web.urlCalled, "url not called.")
        XCTAssertEqual(["contractId": "123", "plainCode": "code345"], web.argsPassed, "Args not passed.")
    }*/
    
    /*func test_getIdAndCodeFromString() {
        let codeString = "abcdefghijklmnopqrst12345"
        
        let result:(id: Int, code: String) = sut.getIdAndCodeFromString(codeString)
        
        let expected = (id: 12345, code: "abcdefghijklmnopqrst")
        XCTAssertEqual(expected.id, result.id)
        XCTAssertEqual(expected.code, result.code)
    }*/
}