import Foundation

class UserDetails: DictionarySettable, DebugPrintable {
    var can_be_messaged = false
    var name            = ""
    var email           = ""
    var connection_id   = 0
    
    func set(dict:[String:AnyObject]) {
        if let _can_be_messaged = dict["can_be_messaged"] as? Bool {
            can_be_messaged = _can_be_messaged
        }
        if let _name = dict["name"] as? String {
            name = _name
        }
        if let _email = dict["email"] as? String {
            email = _email
        }
        if let _connection_id = dict["connection_id"] as? Int {
            connection_id = _connection_id
        }
    }
    
    var debugDescription: String {
        var result = "UserDetails:\n\tcan_be_messaged = \(can_be_messaged)\n\tname = \(name)\n\temail = \(email)\n\tconnection_id = \(connection_id)"
        
        return result;
    }
}