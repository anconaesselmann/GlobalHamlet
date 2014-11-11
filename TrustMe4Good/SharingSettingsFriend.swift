class SharingSettingsFriend: SettingsProtocol {
    func getButtons(groupName: String) -> [String: Bool] {
        if groupName == "identity" {
            return ["show_user_name":false, "show_real_name":true, "show_alias":false, "can_be_messaged": true, "show_email": true, "show_phone": true]
        }
        return Dictionary<String, Bool>()
    }
}