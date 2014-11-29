import Foundation

class Message: APIControllerDelegateProtocol/*, DebugPrintable*/ {
    var delegate:UpdateDelegateProtocol?
    
    var subject = ""
    var message = ""
    var connection_id = 0
    
    init() {}
    
    func didReceiveAPIResults(results: NSDictionary) {
        println("Connection details:")
        println(results)
        if (results["errorCode"] as Int) != 0 {
            NSLog("API request came back with error:")
            println(results["errorCode"])
            return
        }
        var error:NSError?     = nil
        var jsonString:String? = results["response"] as? String
        var jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
        var json:AnyObject?    = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
        if json is [String: AnyObject] {
            set(json as [String: AnyObject])
            if (delegate == nil) {
                NSLog("Delegate of UserDetails is nil")
                return
            }
            delegate!.updateDelegate()
        } else {
            NSLog("User Details could not be initiated")
        }
    }
    func set(dict:[String:AnyObject]) {
        if let _subject = dict["subject"] as? String {
            subject = _subject
        }
        if let _message = dict["message"] as? String {
            message = _message
        }
        if let _connection_id = dict["connection_id"] as? Int {
            connection_id = _connection_id
        }
    }
    
    /*var debugDescription: String {
        var result = "UserDetails:\n\tcan_be_messaged = \(can_be_messaged)\n\tname = \(name)\n\temail = \(email)\n\tconnection_id = \(connection_id)"
        
        return result;
    }
    func displayString() -> String {
        let mail = (email.isEmpty) ? "" : ", \(email)"
        return "\(name)\(mail)"
    }*/
}