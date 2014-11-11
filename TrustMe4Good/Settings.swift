import Foundation

func += <KeyType, ValueType> (
    inout left: Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>
) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

@objc(Settings) class Settings: NSObject {
    var switches:[String: [String:Bool]]    = ["main": Dictionary<String, Bool>()]
    var strings: [String: String]           = Dictionary<String, String>()
    var namedSwitches:[String: NamedSwitch] = Dictionary<String, NamedSwitch>()
    
    func setSwitches(dict: [String: Bool]) {
        setSwitches("main", dict: dict)
    }
    func setSwitches(groupName: String, dict: [String: Bool]) {
        switches[groupName] = dict
        for (name, value) in dict {
            if let namedSwitch = namedSwitches[name] {
                namedSwitch.setOn(value, animated: true)
            }
        }
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
    func setSwitch(groupName: String, key: String, value: Bool) {
        switches[groupName]![key]! = value
        if let namedSwitch = namedSwitches[key]? {
            namedSwitch.setOn(value, animated: true)
        }
    }
    func getSwitch(key: String) -> Bool {
        return getSwitch("main", key: key)
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
        var dict: [String: AnyObject] = Dictionary<String, AnyObject>()
        for (key, value) in switches {
            dict += value
        }
        dict += strings
        return json.toString(dict)
    }
    func linkSwitches(namedSwitches: [NamedSwitch]) {
        for s in namedSwitches {
            self.namedSwitches[s.name] = s
        }
        for (key, dict) in switches {
            for (name, value) in dict {
                if let namedSwitch = self.namedSwitches[name]? {
                    namedSwitch.setOn(value, animated: false)
                }
            }
        }
    }
    func updateNamedSwitch(groupName: String, name: String) {
        if let namedSwitch = namedSwitches[name]? {
            namedSwitch.setOn(switches[groupName]![name]!, animated: true)
        }
    }
}