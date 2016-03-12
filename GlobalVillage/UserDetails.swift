import Foundation

class UserDetails: DictionarySettable, CustomDebugStringConvertible {
    var can_be_messaged = false
    var name            = ""
    var email           = ""
    var phone           = ""
    var connection_id   = 0
    
    @objc func set(dict:[String:AnyObject]) {
        if let _can_be_messaged = dict["can_be_messaged"] as? Bool {
            can_be_messaged = _can_be_messaged
        }
        if let _name = dict["name"] as? String {
            name = _name
        }
        if let _email = dict["email"] as? String {
            email = _email
        }
        if let _phone = dict["phone"] as? String {
            phone = _phone
        }
        if let _connection_id = dict["connection_id"] as? Int {
            connection_id = _connection_id
        }
    }
    
    var debugDescription: String {
        let result = "UserDetails:\n\tcan_be_messaged = \(can_be_messaged)\n\tname = \(name)\n\temail = \(email)\n\tconnection_id = \(connection_id)"
        
        return result;
    }
}