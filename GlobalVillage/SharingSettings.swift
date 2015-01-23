class SharingSettings: Settings {
    override func setSwitch(key: String, value: Bool) {
        if key == "show_user_name" ||
           key == "show_real_name" ||
           key == "show_alias"
        {
            switches["show_user_name"]? = false
            switches["show_real_name"]? = false
            switches["show_alias"]?     = false
            if value == true {
                switches[key]? = value
            } else if value == false {
                switch key {
                case "show_user_name": switches["show_alias"]?     = true
                case "show_real_name": switches["show_alias"]?     = true
                case "show_alias":     switches["show_user_name"]? = true
                default: break
                }
            }
            updateNamedSwitch("show_user_name")
            updateNamedSwitch("show_real_name")
            updateNamedSwitch("show_alias")
        } else {
            super.setSwitch(key, value: value)
        }
    }
}