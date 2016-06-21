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
        if json is [String: AnyObject] {
            target.set(json as! [String: AnyObject])
            self.callback()
        } else {
            NSLog("Could not inistantiate resource")
        }
    }
}