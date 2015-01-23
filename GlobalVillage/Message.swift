import Foundation

class Message: DictionarySettable, DebugPrintable {
    var subject       = ""
    var message       = ""
    var connection_id = 0
    
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
    
    var debugDescription: String {
        return "connection_id: \(connection_id)\nsubject: \(subject)\nmessage: \(message)"
    }
}