import Foundation

@objc protocol SettingsProtocol {
    func setSettingsSwitches(dict: [String: Bool])
//    func setSettingsSwitches() -> [String: Bool]
    func setSwitch(key: String, value: Bool)
    func getSwitch(key: String) -> Bool
    func setString(key: String, value: String)
    func getString(key: String) -> String
    func getJson() -> String
    func linkSwitches(namedSwitches: [NamedSwitch])
    func updateNamedSwitch(name: String)
}