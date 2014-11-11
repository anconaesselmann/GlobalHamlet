import UIKit

class IdentitySharingViewController: DICTableViewController {
    var selectedCategory = 0
    var delegate:InitiateViewController?

    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet var switches: [NamedSwitch]!
    
    /*@IBAction func aliasTextFieldGetsFocus(sender: AnyObject) {
        delegate!.connectionDetails.setSwitch("identity", key: "show_user_name", value: false)
        delegate!.connectionDetails.setSwitch("identity", key: "show_real_name", value: false)
        delegate!.connectionDetails.setSwitch("identity", key: "show_alias",     value: true)
        setSwitches(true)
    }*/
    @IBAction func aliasUdatedAction(sender: AnyObject) {
        delegate!.connectionDetails.setString("alias", value: aliasTextField.text)
        if delegate!.connectionDetails.getSwitch("identity", key: "show_alias") {
            delegate!.identityTextField.text = aliasTextField.text
        }
        println(delegate!.connectionDetails.getString("alias"))
    }
    
    @IBAction func switchValueChangedAction(sender: AnyObject) {
        delegate!.connectionDetails.setSwitch("identity", key: "show_user_name", value: false)
        delegate!.connectionDetails.setSwitch("identity", key: "show_real_name", value: false)
        delegate!.connectionDetails.setSwitch("identity", key: "show_alias",     value: false)
        let switchName = (sender as NamedSwitch).name
        
        if sender.isOn! == true {
            delegate!.connectionDetails.setSwitch("identity", key: switchName, value: true)
        } else if sender.isOn! == false {
            switch switchName {
            case "show_user_name":
                delegate!.connectionDetails.setSwitch("identity", key: "show_alias", value: true)
            case "show_real_name":
                delegate!.connectionDetails.setSwitch("identity", key: "show_alias", value: true)
            case "show_alias":
                delegate!.connectionDetails.setSwitch("identity", key: "show_user_name", value: true)
            default: break
            }
        }


        setSwitches(true)
    }
    func setSwitches(animated: Bool) {
        let switchPositions:[String: Bool] = delegate!.connectionDetails.getSwitches("identity")
        for s in switches {
            s.setOn(switchPositions[s.name]!, animated: animated)
        }

        delegate!.setSwitches(false)
        
        aliasTextField.enabled = false
        if delegate!.connectionDetails.getSwitch("identity", key: "show_alias") {
            aliasTextField.enabled = true
            aliasTextField.becomeFirstResponder()
        }
        println(delegate!.connectionDetails.getJson())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switches[0].name = "show_user_name"
        switches[1].name = "show_real_name"
        switches[2].name = "show_alias"
        
        aliasTextField.text = delegate!.connectionDetails.getString("alias")
        setSwitches(false)
    }
}

