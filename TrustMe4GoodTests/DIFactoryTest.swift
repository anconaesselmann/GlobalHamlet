import UIKit
import XCTest
import Foundation


@objc(MockObject_C_11_04_2014) class MockObject_C_11_04_2014: NSObject, CanSayHello {
    var _var1:String?
    var _var2:Int32?
    var _var3:MockObject_11_04_2014?
    
    func initWithArgs(args:NSArray) {
        _var1 = args[0] as? String
        _var2 = Int32(args[1] as NSInteger)
    }
    func sayHello() -> String {
        if _var1 != nil && _var2 != nil {
            return "\(_var1! as String) \(_var2)"
        } else {
            return "FAIL!!"
        }
    }
}

class DIFactoryTest: XCTestCase {
    var sut:DIFactory!
    
    override func setUp() {
        super.setUp()
        sut = DIFactory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init() {
        let sut = DIFactory()
    }
    
    func test_getClassName() {
        let result = sut.getClassName("testObject")
         XCTAssertEqual("MockObject_11_04_2014", result, "Could not get class name from plist.")
    }
    
    func test_build() {
        if let obj = sut.build("testObject") as? CanSayHello {
            XCTAssertEqual("Hello", obj.sayHello(), "Funcion call does not return Hello.")
        } else {
            XCTFail("Object could not be instanciated.")
        }
    }
    func test_build_with_constructor_args() {
        if let obj = sut.build("testObject2") as? CanSayHello {
            XCTAssertEqual("aString 123", obj.sayHello(), "Funcion call does not return aString 123.")
        } else {
            XCTFail("Object could not be instanciated.")
        }
    }
}