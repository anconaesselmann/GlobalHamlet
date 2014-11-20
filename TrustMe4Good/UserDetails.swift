import Foundation

class UserDetails: APIControllerDelegateProtocol, DebugPrintable {
    var details:[String: AnyObject]?
    var delegate:UserDetailsDelegateProtocol?
    
    var show_address = false
    var can_be_messaged = false
    var show_real_name = false
    var user_name = ""
    var show_alias = false
    var show_phone = false
    var user_email = ""
    var show_email = false
    var status = 0
    var alias = ""
    var show_user_name = false
    
    init() {}
    
    func didReceiveAPIResults(results: NSDictionary) {
        var error:NSError?     = nil
        var jsonString:String? = results["response"] as? String
        var jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
        var json:AnyObject?    = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
        if json is [String: AnyObject] {
            details = json as? [String: AnyObject]
            if (delegate == nil) {
                NSLog("Delegate of UserDetails is nil")
                return
            }
            if let _show_address = details!["show_address"] as? Bool {
                show_address = _show_address
            }
            if let _can_be_messaged = details!["can_be_messaged"] as? Bool {
                can_be_messaged = _can_be_messaged
            }
            if let _show_real_name = details!["show_real_name"] as? Bool {
                show_real_name = _show_real_name
            }
            if let _user_name = details!["user_name"] as? String {
                user_name = _user_name
            }
            if let _show_alias = details!["show_alias"] as? Bool {
                show_alias = _show_alias
            }
            if let _show_phone = details!["show_phone"] as? Bool {
                show_phone = _show_phone
            }
            if let _user_email = details!["user_email"] as? String {
                user_email = _user_email
            }
            if let _show_email = details!["show_email"] as? Bool {
                show_email = _show_email
            }
            if let _status = details!["status"] as? Int {
                status = _status
            }
            if let _alias = details!["alias"] as? String {
                alias = _alias
            }
            if let _show_user_name = details!["show_user_name"] as? Bool {
                show_user_name = _show_user_name
            }
            delegate!.userDetailsHaveUpdated()
        } else {
            NSLog("User Details could not be initiated")
        }
    }
    
    func getName() -> String {
        if show_alias {
            return alias
        }
        if show_user_name {
            return user_name
        }
        return "CORRUPTED_DATA"
    }
    
    var debugDescription: String {
        var result = "UserDetails:\n\tshow_address = \(show_address)\n\tcan_be_messaged = \(can_be_messaged)\n\tshow_real_name = \(show_real_name)\n\tuser_name = \(user_name)\n\tshow_alias = \(show_alias)\n\tshow_phone = \(show_phone)\n\tuser_email = \(user_email)\n\tshow_email = \(show_email)\n\tstatus = \(status)\n\talias = \(alias)\n\tshow_user_name = \(show_user_name)"
        
        
        return result;
    }
}