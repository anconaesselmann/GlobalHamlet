import Foundation

class AsynchronousArrayResourceInstantiator: APIControllerDelegateProtocol {
    var addInstanceClosure:(([String: AnyObject]) -> Void)!
    var callback:(() -> Void)!
    
    
    init(addInstanceClosure:([String: AnyObject]) -> Void, callback:() ->Void) {
        self.addInstanceClosure = addInstanceClosure
        self.callback = callback
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        println("API request results:")
        println(results)
        if (results["errorCode"] as Int) != 0 {
            NSLog("API request came back with error:")
            println(results["errorCode"])
            return
        }
        var error:NSError?     = nil
        var jsonString:String? = results["response"] as? String
        var jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
        if jsonData == nil {
            NSLog("Error decoding json for response:")
            println(results)
            return
        }
        var json:AnyObject?    = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
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