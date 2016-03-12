import Foundation

class OwnDetails: DictionarySettable, CustomDebugStringConvertible {
    var firstName = ""
    var lastName = ""
    var phoneNbr = ""
    var address = ""
    var city = ""
    var zip = ""
    var state = ""
    var country = ""
    var imageUrl = ""
    
    @objc func set(dict:[String:AnyObject]) {
        if let _imageUrl = dict["imageUrl"] as? String {
            imageUrl = _imageUrl
        }
        if let _country = dict["country"] as? String {
            country = _country
        }
        if let _state = dict["state"] as? String {
            state = _state
        }
        if let _zip = dict["zip"] as? String {
            zip = _zip
        }
        if let _city = dict["city"] as? String {
            city = _city
        }
        if let _address = dict["address"] as? String {
            address = _address
        }
        if let _phoneNbr = dict["phoneNbr"] as? String {
            phoneNbr = _phoneNbr
        }
        if let _lastName = dict["lastName"] as? String {
            lastName = _lastName
        }
        if let _firstName = dict["firstName"] as? String {
            firstName = _firstName
        }
    }
    
    var debugDescription: String {
        return "firstName: \(firstName)\nlastName: \(lastName)"
    }
}