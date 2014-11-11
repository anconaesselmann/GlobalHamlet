import Foundation

@objc(Settings) class Settings: NSObject {
    var switches:[String: [String:Bool]] = ["main": Dictionary<String, Bool>()]
    var strings: [String: String] = Dictionary<String, String>()
    
    func setSwitches(dict: [String: Bool]) {
        setSwitches("main", dict: dict)
    }
    func setSwitches(groupName: String, dict: [String: Bool]) {
        switches[groupName] = dict
    }
    func getSwitches() -> [String: Bool] {
        return getSwitches("main")
    }
    func getSwitches(groupName: String) -> [String: Bool] {
        return switches[groupName]!
    }
    func setSwitch(key: String, value: Bool) {
        setSwitch("main", key: key, value: value)
    }
    func getSwitch(key: String) -> Bool {
        return getSwitch("main", key: key)
    }
    func setSwitch(groupName: String, key: String, value: Bool) {
        switches[groupName]![key]! = value
    }
    func getSwitch(groupName: String, key: String) -> Bool {
        return switches[groupName]![key]!
    }
    func setString(key: String, value: String) {
        strings[key] = value
    }
    func getString(key: String) -> String {
        return strings[key]!
    }
    func getJson() -> String {
        let json = JSON()
        return json.toString(["bools":switches, "strings":strings])
    }
}