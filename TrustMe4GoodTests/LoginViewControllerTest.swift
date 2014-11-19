import UIKit
import XCTest

class LoginViewControllerTests: XCTestCase {
    var sut : LoginViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
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
            let result = contains(actions as [String], "signInAction:")
            XCTAssertTrue(result, "No TouchUpInside event of name signIn exist.")
        } else {
            XCTFail("No TouchUpInside events exists.")
        }
    }
    func test_emailLabel_should_be_connected() {
        XCTAssertNotNil(sut.emailTextField, "email text field not connected")
    }
    
    func test_passwordLabel_should_be_connected() {
        XCTAssertNotNil(sut.passwordTextField, "password text field not connected")
    }
    
    /*func test_signInAction_should_validate_password_and_return_true_when_valid() {
        sut.web = Web_Mock_11_06_14()
        sut.signInAction(UIButton());
        XCTAssertTrue(sut.loggedIn, "signInAction should set loggedIn to true when supplied with correct login information.")
    }
    func test_signInAction_should_validate_password_and_return_false_when_invalid() {
        let mock = Web_Mock_11_06_14()
        mock.loggedIn = false
        sut.web = mock
        sut.signInAction(UIButton());
        XCTAssertFalse(sut.loggedIn, "signInAction should set loggedIn to false when supplied with incorrect login information.")
        XCTAssertEqual("Error signing in.", sut.infoLabel.text!, "A failed login action should update the info label.")
    }*/
    func test_infoLabel_should_be_connected() {
        XCTAssertNotNil(sut.infoLabel, "Info label not connected")
    }
}

class Web_Mock_11_06_14: WebProtocol {
    var loggedIn = true
    func postRequst(urlString: String, arguments: Dictionary<String, String>?) -> NSDictionary {
        return NSDictionary(dictionary: ["response": loggedIn, "errorCode": 0])
        
    }
    func postRequst(urlString: String) -> NSDictionary {
        return NSDictionary(dictionary: ["response": loggedIn, "errorCode": 0])
    }
    func getResponseWithError(url:String, error:Error) -> AnyObject? {
        return ""
    }
    func getResponseWithError(url:String, arguments: Dictionary<String, String>, error:Error) -> AnyObject? {
        return ""
    }
}