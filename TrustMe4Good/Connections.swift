import Foundation

class Connections: APIControllerDelegateProtocol/*, DebugPrintable*/ {
    var connections:[UserDetails] = []
    var delegate:UpdateDelegateProtocol?
    
    init() {}
    
    func didReceiveAPIResults(results: NSDictionary) {
        var error:NSError?     = nil
        var jsonString:String? = results["response"] as? String
        var jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
        var json:AnyObject?    = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
        if json is [[String: AnyObject]] {
            let connectionsArray:[[String:AnyObject]]? = json as? [[String: AnyObject]]
            set(connectionsArray)
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