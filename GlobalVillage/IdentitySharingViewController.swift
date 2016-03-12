import UIKit

class IdentitySharingViewController: DICTableViewController {
    var delegate:InitiateViewController?

    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet var switches: [NamedSwitch]!
    
    @IBAction func aliasUdatedAction(sender: AnyObject) {
        delegate!.connectionDetails.setString("alias", value: aliasTextField.text!)
        if delegate!.connectionDetails.getSwitch("show_alias") {
            delegate!.identityTextField.text = aliasTextField.text
        }
    }
    
    @IBAction func switchValueChangedAction(sender: AnyObject) {
        delegate!.connectionDetails.setSwitch(
            (sender as! NamedSwitch).name,
            value: sender.isOn
        )
        setAliasTextField()
        //println(delegate!.connectionDetails.getJson())
    }
    
    func setAliasTextField() {
        aliasTextField.text = delegate!.connectionDetails.getString("alias")
        if delegate!.connectionDetails.getSwitch("show_alias") {
            aliasTextField.enabled = true
            aliasTextField.becomeFirstResponder()
        } else {
            aliasTextField.enabled = false
        }
        delegate!.setIdentityTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switches[0].name = "show_user_name"
        switches[1].name = "show_real_name"
        switches[2].name = "show_alias"
        
        delegate!.connectionDetails.linkSwitches(switches)
        setAliasTextField()
    }
}

