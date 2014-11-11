class SharingSettings: Settings {
    override func setSwitch(groupName: String, key: String, value: Bool) {
        if groupName == "identity" {
            switches["identity"]?["show_user_name"]? = false
            switches["identity"]?["show_real_name"]? = false
            switches["identity"]?["show_alias"]?     = false
            if value == true {
                switches["identity"]?[key]? = value
            } else if value == false {
                switch key {
                case "show_user_name": switches["identity"]?["show_alias"]?     = true
                case "show_real_name": switches["identity"]?["show_alias"]?     = true
                case "show_alias":     switches["identity"]?["show_user_name"]? = true
                default: break
                }
            }
            updateNamedSwitch("identity", name: "show_user_name")
            updateNamedSwitch("identity", name: "show_real_name")
            updateNamedSwitch("identity", name: "show_alias")
        } else {
            super.setSwitch(groupName, key: key, value: value)
        }
    }
}