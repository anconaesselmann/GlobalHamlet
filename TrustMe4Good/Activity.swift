import Foundation

class Activity: APIControllerDelegateProtocol, DebugPrintable {
    var details:[String: AnyObject]?
    var delegate:UpdateDelegateProtocol?
    
    var time = ""
    var actor = ""
    var action = ""
    var activity_id = 0
    var category = ""
    var category_id = 0
    
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
            details = json as? [String: AnyObject]
            set(details!)
            if (delegate == nil) {
                NSLog("Delegate of Activity is nil")
                return
            }
            delegate!.updateDelegate()
        } else {
            NSLog("User Details could not be initiated")
        }
    }
    func set(dict:[String:AnyObject]) {
        if let _time = dict["time"] as? String {
            time = _time
        }
        if let _actor = dict["actor"] as? String {
            actor = _actor
        }
        if let _action = dict["action"] as? String {
            action = _action
        }
        if let _activity_id = dict["activity_id"] as? String {
            activity_id = _activity_id.toInt()!
        }
        if let _category = dict["category"] as? String {
            category = _category
        }
        if let _category_id = dict["category_id"] as? String {
            category_id = _category_id.toInt()!
        }
    }
    
    func getName() -> String {
        return actor
    }
    
    var debugDescription: String {
        var result = "Activity:\n\ttime = \(time)\n\tactor = \(actor)\n\taction = \(action)\n\tactivity_id = \(activity_id)"
        
        return result;
    }
    func displayString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateFromString:NSDate! = dateFormatter.dateFromString(time)
        
        dateFormatter.dateFormat = "MMM d, H:mm"
        dateFormatter.timeZone = NSTimeZone()
        let stringDate: String = dateFormatter.stringFromDate(dateFromString)
        
        var result:String!
        if category == "connections" {
            let type = (action == "initiated") ? "Initiated" : "Accepted"
            result = "\(type) connection with \(actor)"
        } else if category == "messages" {
            let type = (action == "sent") ? "sent to" : "recieved from"
            result = "Message \(type) \(actor)"
        }
        return "\(stringDate): \(result)"
    }
}