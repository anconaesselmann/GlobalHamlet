import UIKit
import XCTest

/*class FirstLaunchViewControllerTests: XCTestCase {
    var sut : FirstLaunchViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("FirstLaunchViewController") as FirstLaunchViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_sign_in_button_should_be_connected() {
        XCTAssertNotNil(sut.signInButton, "Sign In button not connected")
    }
    func test_sign_in_button_action() {
        let button  = sut.signInButton
        let event   = UIControlEvents.TouchUpInside
        let actions = button.actionsForTarget(sut, forControlEvent: event)
        
        if actions != nil {
            let result = contains(actions as [String], "signIn:")
            XCTAssertTrue(result, "No TouchUpInside event of name signIn exist.")
        } else {
            XCTFail("No TouchUpInside events exists.")
        }
    }
}*/