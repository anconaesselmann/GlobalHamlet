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
}