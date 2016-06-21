import Foundation

class AsynchronousArrayResourceInstantiator: APIControllerDelegateProtocol {
    var addInstanceClosure:(([String: AnyObject]) -> Void)!
    var callback:(() -> Void)!
    
    
    init(addInstanceClosure:([String: AnyObject]) -> Void, callback:() ->Void) {
        self.addInstanceClosure = addInstanceClosure
        self.callback = callback
    }
    
    @objc func didReceiveAPIResults(results: NSDictionary) {
        print("API request results:")
        print(results)
        if (results["errorCode"] as! Int) != 0 {
            NSLog("API request came back with error:")
            print(results["errorCode"])
            return
        }
        var error:NSError?     = nil
        let jsonString:String? = results["response"] as? String
        let jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
        if jsonData == nil {
            NSLog("Error decoding json for response:")
            print(results)
            return
        }
        var json:AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: [])
        } catch let error1 as NSError {
            error = error1
            json = nil
            print(error)
        };
        if json is [[String: AnyObject]] {
            set(json as? [[String: AnyObject]])
        } else {
            NSLog("Could not inistantiate resource")
        }
    }
    
    func set(array: [[String: AnyObject]]?) {
        if array != nil {
            for connection in array! {
                addInstanceClosure(connection)
            }
            callback()
        }
    }
}