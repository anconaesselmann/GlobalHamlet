import Foundation
import UIKit
import XCTest

class MainViewControllerTest: XCTestCase {
    var sut : MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*func test_prepareForSegue() {
        let destination = Mock_DiViewController()
        var segue = Mock_Segue(
            identifier: "SegueToFirstLaunchView",
            source: sut,
            destination: destination
        )
        let web = Web_Mock()
        sut.web = web as WebProtocol
        sut.url = "test.dev"
        sut.prepareForSegue(segue, sender: nil)
        
        XCTAssertEqual(
            "test.dev/login/logout",
            web.urlCalled,
            "web did not call logout."
        )
    }*/
}