class SharingSettingsCasual: SettingsProtocol {
    func getButtons(groupName: String) -> [String: Bool] {
        if groupName == "identity" {
            return ["show_user_name":true, "show_real_name":false, "show_alias":false, "can_be_messaged": true, "show_email": true, "show_phone": false]
        }
        return Dictionary<String, Bool>()
    }
}