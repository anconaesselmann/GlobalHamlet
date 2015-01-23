import Foundation

@objc(ConnectionDetails) class ConnectionDetails: NSObject {
    var settings:[String: Bool] = ["show_user_name":false, "show_real_name":false, "show_alias":false]
    var alias: String = ""
    
    func setRestricted() {
        settings = ["show_user_name":false, "show_real_name":false, "show_alias":true]
    }
    func setCasual() {
        settings = ["show_user_name":true, "show_real_name":false, "show_alias":false]
    }
    func setFriend() {
        settings = ["show_user_name":false, "show_real_name":true, "show_alias":false]
    }
    func setSetting(key: String, value: Bool) {
        settings[key] = value
    }
    func getSetting(key: String) -> Bool {
        return settings[key]!
    }
    func getSwitchSettings() -> [Bool] {
        var switches = [Bool]()
        switches.append(settings["show_user_name"]!)
        switches.append(settings["show_real_name"]!)
        switches.append(settings["show_alias"]!)
        return switches
    }
    func getIdentitySwitchSettings() -> [Bool] {
        var switches = [Bool]()
        switches.append(settings["show_user_name"]!)
        switches.append(settings["show_real_name"]!)
        switches.append(settings["show_alias"]!)
        return switches
    }
    func getJson() -> String {
        let json = JSON()
        return json.toString(["settings":settings, "alias":alias])
    }
}