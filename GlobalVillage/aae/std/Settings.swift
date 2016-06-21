import Foundation

func += <KeyType, ValueType> (
    inout left: Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>
) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

@objc(Settings) class Settings: NSObject, SettingsProtocol {
    var switches:[String:Bool]    = Dictionary<String, Bool>()
    var strings: [String: String]           = Dictionary<String, String>()
    var namedSwitches:[String: NamedSwitch] = Dictionary<String, NamedSwitch>()
    
    func setSettingsSwitches(dict: [String: Bool]) {
        switches = dict
        for (name, value) in dict {
            if let namedSwitch = namedSwitches[name] {
                namedSwitch.setOn(value, animated: true)
            }
        }
    }
    func getSwitches() -> [String: Bool] {
        return switches
    }
    func setSwitch(key: String, value: Bool) {
        switches[key]! = value
        if let namedSwitch = namedSwitches[key] {
            namedSwitch.setOn(value, animated: true)
        }
    }
    func getSwitch(key: String) -> Bool {
        return switches[key]!
    }
    func setString(key: String, value: String) {
        strings[key] = value
    }
    func getString(key: String) -> String {
        return strings[key]!
    }
    func getJson() -> String {
//        let json = JSON()
//        var dict: [String: AnyObject] = Dictionary<String, AnyObject>()
//        dict += switches
//        dict += strings
//        return json.toString(dict)
        return ""
    }
    func linkSwitches(namedSwitches: [NamedSwitch]) {
        for s in namedSwitches {
            self.namedSwitches[s.name] = s
        }
        for (name, value) in switches {
            if let namedSwitch = self.namedSwitches[name] {
                namedSwitch.setOn(value, animated: false)
            }
        }
    }
    func updateNamedSwitch(name: String) {
        if let namedSwitch = namedSwitches[name] {
            namedSwitch.setOn(switches[name]!, animated: true)
        }
    }
}