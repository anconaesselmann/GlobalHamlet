import UIKit
import XCTest

class AsynchronousResourceInstantiatorTest: XCTestCase {
    var sut : AsynchronousResourceInstantiator!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_didReceiveAPIResults() {
        var targetInstance = Mock_dummy_class_12_01_14()
        var called = false
        func callback() {
            called = true
        }
        sut = AsynchronousResourceInstantiator(target: targetInstance, callback: callback)
        
        let response = "{\"var1\":\"works1\",\"var2\":\"works2\"}"
        let results = NSDictionary(dictionary:["response":response,"errorCode":0])
        
        sut.didReceiveAPIResults(results)
        
        XCTAssertTrue(called)
        XCTAssert(targetInstance.var1 == "works1")
        XCTAssert(targetInstance.var2 == "works2")
    }
}
class Mock_dummy_class_12_01_14: DictionarySettable {
    var var1:String = ""
    var var2:String = ""
    
    @objc func set(dict:[String:AnyObject]) {
        if let var1 = dict["var1"] as? String {
            self.var1 = var1
        }
        if let var2 = dict["var2"] as? String {
            self.var2 = var2
        }
    }
}