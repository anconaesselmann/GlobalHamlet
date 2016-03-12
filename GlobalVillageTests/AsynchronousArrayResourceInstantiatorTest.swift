import UIKit
import XCTest

class AsynchronousArrayResourceInstantiatorTest: XCTestCase {
    var sut : AsynchronousArrayResourceInstantiator!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_didReceiveAPIResults() {
        var targetInstances:[Mock_dummy_class_12_01_14] = []
        var called = false
        func callback() {
            called = true
        }
        sut = AsynchronousArrayResourceInstantiator(
            addInstanceClosure: {(dict:[String: AnyObject]) -> Void in
                let inst = Mock_dummy_class_12_01_14()
                inst.set(dict)
                targetInstances.append(inst)
            },
            callback: callback
        )
        
        let response = "[{\"var1\":\"works1\",\"var2\":\"works2\"},{\"var1\":\"works3\",\"var2\":\"works4\"}]"
        let results = NSDictionary(dictionary:["response":response,"errorCode":0])
        
        sut.didReceiveAPIResults(results)
        
        XCTAssertTrue(called)
        XCTAssert(targetInstances[0].var1 == "works1")
        XCTAssert(targetInstances[0].var2 == "works2")
        
        XCTAssert(targetInstances[1].var1 == "works3")
        XCTAssert(targetInstances[1].var2 == "works4")
    }
}