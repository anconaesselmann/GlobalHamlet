import UIKit
import XCTest

class IdentitySharingViewControllerTest: XCTestCase {
    var sut : IdentitySharingViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        sut = storyboard.instantiateViewControllerWithIdentifier("IdentitySharingViewController") as IdentitySharingViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_prepareForSegue() {
        
    }
}