class SharingSettingsRestricted: SettingsProtocol {
    func getButtons(groupName: String) -> [String: Bool] {
        if groupName == "identity" {
            return ["show_user_name":false, "show_real_name":false, "show_alias":true]
        }
        return Dictionary<String, Bool>()
    }
}