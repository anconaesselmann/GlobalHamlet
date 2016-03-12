import UIKit
import XCTest

class InitiateViewControllerTests: XCTestCase {
    var sut : InitiateViewController!
    var settings = Mock_Settings()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("InitiateViewController") as! InitiateViewController
        sut.connectionDetails = settings
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*func test_prepareForSegue() {
        let destination = Mock_DiViewController_11_08_14_Destination()
        let contractId  = 1
        let plainCode   = "plain1234"
        var segue = Mock_Segue(
            identifier: "InitiateQRSegue",
            source: sut,
            destination: destination
        )
        let web = Web_Mock()
        web.urlCallResult = [
            "connectionId": contractId,
            "plainCode": plainCode
        ]
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.prepareForSegue(segue, sender: nil)
        
        XCTAssertEqual("test.dev/connection/initiate", web.urlCalled)
        XCTAssertEqual(contractId, destination.contractId!)
        XCTAssertEqual(plainCode, destination.plainCode!)
    }*/
    /*func test_prepareForSegue_sets_error_code() {
        sut.error.errorCode = 123
        let destination     = Mock_DiViewController_11_08_14_Destination()
        var segue = Mock_Segue(
            identifier: "InitiateQRSegue",
            source: sut,
            destination: destination
        )
        let web = Web_Mock()
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.prepareForSegue(segue, sender: nil)
        
        XCTAssertEqual("test.dev/connection/initiate", web.urlCalled)
        XCTAssertEqual(123, destination.error.errorCode)
    }*/
    
    /*func test_getOtherDetails() {
        let id = 22;
        let web = Web_Mock()
        let args = ["id": String(id)]
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        
        sut.getOtherDetails(id);
        XCTAssertEqual("test.dev/connection/other_details", web.urlCalled)
        XCTAssertEqual(args, web.argsPassed)
    }*/
}
class Mock_DiViewController_11_08_14_Destination: InitiateQRViewController {}