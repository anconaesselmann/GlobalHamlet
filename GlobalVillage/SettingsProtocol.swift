import Foundation

@objc protocol SettingsProtocol {
    func setSwitches(dict: [String: Bool])
    func getSwitches() -> [String: Bool]
    func setSwitch(key: String, value: Bool)
    func getSwitch(key: String) -> Bool
    func setString(key: String, value: String)
    func getString(key: String) -> String
    func getJson() -> String
    func linkSwitches(namedSwitches: [NamedSwitch])
    func updateNamedSwitch(name: String)
}