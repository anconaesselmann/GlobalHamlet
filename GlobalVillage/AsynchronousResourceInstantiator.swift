import Foundation

@objc protocol DictionarySettable {
    func set(dict:[String:AnyObject])
}
class AsynchronousResourceInstantiator: APIControllerDelegateProtocol {
    var target:AnyObject!
    var callback:(() -> Void)!
    
    
    init(target:AnyObject, callback:() ->Void) {
        self.target = target
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
        if json is [String: AnyObject] {
            target.set(json as [String: AnyObject])
            self.callback()
        } else {
            NSLog("Could not inistantiate resource")
        }
    }
}