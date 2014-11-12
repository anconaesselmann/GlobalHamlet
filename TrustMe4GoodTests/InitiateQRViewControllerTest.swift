import UIKit
import XCTest

class InitiateQRViewControllerTest: XCTestCase {
    var sut : InitiateQRViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("InitiateQRViewController") as InitiateQRViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_prepareForSegue() {
        let destination = Mock_DiViewController()
        var segue       = Mock_Segue(
            identifier: "DeleteInitContractsSegue",
            source: sut,
            destination: destination
        )
        let web = Web_Mock()
        web.urlCallResult = [
            "errorCode": 0,
            "response": true]
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.prepareForSegue(segue, sender: nil)
        
        XCTAssertEqual("test.dev/connection/deleteinitiated", web.urlCalled)
    }
    func test_prepareForSegue_delete_not_called_if_error() {
        let destination = Mock_DiViewController()
        sut.error.errorCode   = 123
        var segue = Mock_Segue(
            identifier: "DeleteInitContractsSegue",
            source: sut,
            destination: destination
        )
        let web = Web_Mock()
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.prepareForSegue(segue, sender: nil)
        
        XCTAssertEqual("", web.urlCalled)
    }
}