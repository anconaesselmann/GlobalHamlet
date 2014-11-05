import UIKit
import XCTest
import Foundation

@objc protocol CanSayHello {
    func sayHello() -> String
}

@objc(MockObject_11_04_2014) class MockObject_11_04_2014: NSObject, CanSayHello {
    func sayHello() -> String {
        return "Hello"
    }
    override var description : String {return "MockObject_11_04_2014"}
}
@objc(MockObject_B_11_04_2014) class MockObject_B_11_04_2014: NSObject, InitArgsInterface, CanSayHello {
    
    var _var1:String!
    var _var2:Int32!
    
    
    func initWithArgs(args:[AnyObject]) {
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

class SimpleFactoryTest: XCTestCase {
    var sut:SimpleFactory!
    
    override func setUp() {
        super.setUp()
        sut = SimpleFactory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init() {
        let sut = SimpleFactory()
    }
    
    func test_build() {
        if let obj = sut.build("MockObject_11_04_2014") as? CanSayHello {
            XCTAssertEqual("Hello", obj.sayHello(), "Funcion call does not return Hello.")
        } else {
            XCTFail("Object could not be instanciated.")
        }
    }
    func test_build_with_args() {
        let args = ["aString", 123] as NSArray
        if let obj = sut.buildWithArgs("MockObject_B_11_04_2014", args: args) as? CanSayHello {
            XCTAssertEqual("aString 123", obj.sayHello(), "Funcion call does not return aString 123.")
        } else {
            XCTFail("Object could not be instanciated.")
        }
    }
}