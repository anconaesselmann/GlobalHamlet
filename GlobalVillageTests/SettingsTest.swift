import UIKit
import XCTest

class SettingsTest: XCTestCase {
    var sut : Settings!
    
    override func setUp() {
        super.setUp()
        sut = Settings()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_initSwitches() {
        let initDict = ["s1": true, "s2": false, "s3": false, "s4": true]
        sut.setSwitches(initDict)
        XCTAssertEqual(initDict, sut.getSwitches())
    }
    func test_setSwitch() {
        let initDict = ["s1": true, "s2": false, "s3": false, "s4": true]
        let expected = ["s1": true, "s2": true, "s3": false, "s4": true]
        let key = "s2"
        let value = true
        sut.setSwitches(initDict)
        sut.setSwitch(key, value: value)
        XCTAssertEqual(expected, sut.getSwitches())
    }
    func test_getSwitch() {
        let initDict = ["s1": true, "s2": false, "s3": false, "s4": true]
        let key = "s2"
        sut.setSwitches(initDict)
        XCTAssertFalse(sut.getSwitch(key))
    }
    func test_setString() {
        let value = "aString"
        let key   = "aKey"
        sut.setString(key, value: value)
        XCTAssertEqual(value, sut.getString(key))
    }
    func test_getJson() {
        let initDict = ["s1": true, "s2": false, "s3": false, "s4": true]
        let value = "aString"
        let key   = "aKey"
        sut.setSwitches(initDict)
        sut.setString(key, value: value)
        println(sut.getJson())
        println("\n\n\n\n\n\n\n\n\n")
        XCTAssertEqual("{\"s2\":false,\"s1\":true,\"s4\":true,\"aKey\":\"aString\",\"s3\":false}", sut.getJson())
    }
    
}