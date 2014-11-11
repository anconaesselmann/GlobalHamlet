import UIKit
import XCTest

class IdentitySharingViewControllerTest: XCTestCase {
    var sut : IdentitySharingViewController!
    var delegate : InitiateViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        delegate = storyboard.instantiateViewControllerWithIdentifier("InitiateViewController") as InitiateViewController
        delegate.loadView()
        delegate.viewDidLoad()

        sut = storyboard.instantiateViewControllerWithIdentifier("IdentitySharingViewController") as IdentitySharingViewController
        sut.delegate = delegate
        sut.loadView()
        sut.viewDidLoad()
    }
    
    func test_switches_connected() {
        XCTAssertNotNil(sut.switches, "Switches not connected!")
        var switchNames:[String] = Array<String>()
        let expectedSwitchNames = ["show_user_name", "show_real_name", "show_alias"]
        for s in sut.switches {
            switchNames.append(s.name)
        }
        for n in expectedSwitchNames {
            XCTAssertTrue(contains(switchNames, n))
        }
    }
}