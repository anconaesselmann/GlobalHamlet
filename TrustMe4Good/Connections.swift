import Foundation

//class Connections: APIControllerDelegateProtocol, DebugPrintable {
//    var connection: NSMutableArray?
//    var delegate:UpdateDelegateProtocol?
//    
//    init() {}
//    
//    func didReceiveAPIResults(results: NSDictionary) {
//        var error:NSError?     = nil
//        var jsonString:String? = results["response"] as? String
//        var jsonData:NSData?   = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
//        var json:AnyObject?    = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
//        if json is [String: AnyObject] {
//            details = json as? [[String: AnyObject]]
//            if (delegate == nil) {
//                NSLog("Delegate of UserDetails is nil")
//                return
//            }
//            
//            
//            delegate!.updateDelegate()
//        } else {
//            NSLog("User Details could not be initiated")
//        }
//    }
//    
//    /*var debugDescription: String {
//        var result = "UserDetails:\n\tshow_address = \(show_address)\n\tcan_be_messaged = \(can_be_messaged)\n\tshow_real_name = \(show_real_name)\n\tuser_name = \(user_name)\n\tshow_alias = \(show_alias)\n\tshow_phone = \(show_phone)\n\tuser_email = \(user_email)\n\tshow_email = \(show_email)\n\tstatus = \(status)\n\talias = \(alias)\n\tshow_user_name = \(show_user_name)"
//        
//        
//        return result;
//    }*/
//}