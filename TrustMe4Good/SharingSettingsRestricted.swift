class SharingSettingsRestricted: SettingsProtocol {
    func getButtons(groupName: String) -> [String: Bool] {
        if groupName == "identity" {
            return ["show_user_name":false, "show_real_name":false, "show_alias":true, "can_be_messaged": false, "show_email": false, "show_phone": false]
        }
        return Dictionary<String, Bool>()
    }
}