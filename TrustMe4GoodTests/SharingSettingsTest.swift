import UIKit
import XCTest

class SharingSettingsTest: XCTestCase {
    var sut : SharingSettings!
    
    override func setUp() {
        super.setUp()
        sut = SharingSettings()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_show_user_name_equal_true_sets_other_to_false() {
        let initDict = ["show_user_name": false, "show_real_name": true, "show_alias": true]
        let expectedDict = ["show_user_name": true, "show_real_name": false, "show_alias": false]
        sut.setSwitches(initDict)
        sut.setSwitch("show_user_name", value: true)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
    
    func test_show_real_name_equal_true_sets_other_to_false() {
        let initDict = ["show_user_name": true, "show_real_name": false, "show_alias": true]
        let expectedDict = ["show_user_name": false, "show_real_name": true, "show_alias": false]
        sut.setSwitches(initDict)
        sut.setSwitch("show_real_name", value: true)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
    
    func test_show_alias_equal_true_sets_other_to_false() {
        let initDict = ["show_user_name": true, "show_real_name": true, "show_alias": false]
        let expectedDict = ["show_user_name": false, "show_real_name": false, "show_alias": true]
        sut.setSwitches(initDict)
        sut.setSwitch("show_alias", value: true)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
    
    func test_show_user_name_equal_false_sets_show_alias_true() {
        let initDict = ["show_user_name": true, "show_real_name": true, "show_alias": false]
        let expectedDict = ["show_user_name": false, "show_real_name": false, "show_alias": true]
        sut.setSwitches(initDict)
        sut.setSwitch("show_user_name", value: false)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
    
    func test_show_real_name_equal_false_sets_show_alias_true() {
        let initDict = ["show_user_name": true, "show_real_name": false, "show_alias": true]
        let expectedDict = ["show_user_name": false, "show_real_name": false, "show_alias": true]
        sut.setSwitches(initDict)
        sut.setSwitch("show_real_name", value: false)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
    
    func test_show_alias_equal_false_sets_show_alias_true() {
        let initDict = ["show_user_name": true, "show_real_name": true, "show_alias": false]
        let expectedDict = ["show_user_name": true, "show_real_name": false, "show_alias": false]
        sut.setSwitches(initDict)
        sut.setSwitch("show_alias", value: false)
        XCTAssertEqual(expectedDict, sut.getSwitches())
    }
}