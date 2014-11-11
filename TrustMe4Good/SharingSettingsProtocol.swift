protocol SettingsProtocol {
    func getButtons(groupName: String) -> [String: Bool]
}