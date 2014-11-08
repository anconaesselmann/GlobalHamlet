import UIKit
import XCTest

class InitiateViewControllerTests: XCTestCase {
    var sut : InitiateViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("InitiateViewController") as InitiateViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_sign_in_button_should_be_connected() {
        //XCTAssertNotNil(sut.signInButton, "Sign In button not connected")
    }
}