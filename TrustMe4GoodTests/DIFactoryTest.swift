import UIKit
import XCTest
import Foundation


@objc(MockObject_C_11_04_2014) class MockObject_C_11_04_2014: NSObject, CanSayHello, InitArgsInterface {
    var _var1:MockObject_11_04_2014!
    
    func initWithArgs(args:[AnyObject]) {
        _var1 = args[0] as? MockObject_11_04_2014
    }
    func sayHello() -> String {
        if _var1 != nil {
            return "From C: \(_var1.sayHello())"
        } else {
            return "FAIL!!"
        }
    }
}

class DIFactoryTest: XCTestCase {
    var sut:DIFactory!
    
    override func setUp() {
        super.setUp()
        sut = DIFactory(fileName: "configTest")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init() {
        let sut = DIFactory(fileName: "configTest")
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
    func test_build_with_dependency_constructor_arg() {
        if let obj = sut.build("testObject3") as? CanSayHello {
            XCTAssertEqual("From C: Hello", obj.sayHello(), "Funcion call does not return From C: Hello.")
        } else {
            XCTFail("Object could not be instanciated.")
        }
    }
    func test_decorate() {
        var obj = MockObject_B_11_04_2014()
        XCTAssertEqual("FAIL!!", obj.sayHello(), "Funcion call does not return aString 123.")
        sut.decorate(obj, idString: "testObject2")
        XCTAssertEqual("aString 123", obj.sayHello(), "Funcion call does not return aString 123.")
    }
}