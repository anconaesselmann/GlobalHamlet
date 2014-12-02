import Foundation

class Connections: APIControllerDelegateProtocol/*, DebugPrintable*/ {
    var connections:[UserDetails] = []
    var delegate:UpdateDelegateProtocol?
    
    init() {}
    
    func didReceiveAPIResults(results: NSDictionary) {
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
            if (delegate == nil) {
                NSLog("Delegate of Connections is nil")
                return
            }
            delegate!.updateDelegate()
        } else {
            NSLog("User Details could not be initiated")
        }
    }
    
    func set(array: [[String: AnyObject]]?) {
        if array != nil {
            for connection in array! {
                var ud = UserDetails()
                ud.set(connection)
                connections.append(ud)
            }
        }
    }
}