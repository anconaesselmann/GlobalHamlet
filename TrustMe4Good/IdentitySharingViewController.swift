import UIKit

class IdentitySharingViewController: DICTableViewController {
    var selectedCategory = 0
    var delegate:InitiateViewController?

    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet var switches: [UISwitch]!
    
    @IBAction func aliasUdatedAction(sender: AnyObject) {
        delegate!.connectionDetails.alias = aliasTextField.text
        println(delegate!.connectionDetails.alias)
    }
    
    @IBAction func switchValueChangedAction(sender: AnyObject) {
        delegate!.connectionDetails.setSetting("show_user_name", value: false)
        delegate!.connectionDetails.setSetting("show_real_name", value: false)
        delegate!.connectionDetails.setSetting("show_alias",     value: false)
        if sender.isOn! == true {
            switch sender.tag {
            case 0: delegate!.connectionDetails.setSetting("show_user_name", value: true)
            case 1: delegate!.connectionDetails.setSetting("show_real_name", value: true)
            case 2: delegate!.connectionDetails.setSetting("show_alias",     value: true)
            default: break
            }
        } else if sender.isOn! == false {
            switch sender.tag {
            case 0: delegate!.connectionDetails.setSetting("show_alias",     value: true)
            case 1: delegate!.connectionDetails.setSetting("show_alias",     value: true)
            case 2: delegate!.connectionDetails.setSetting("show_user_name", value: true)
            default: break
            }
        }
        setSwitches(true)
        delegate!.setSwitches(false)
        
        println(delegate!.connectionDetails.getJson())
    }
    func setSwitches(animated: Bool) {
        let switchPositions:[Bool] = delegate!.connectionDetails.getIdentitySwitchSettings()
        for index in 0...(switches.count - 1) {
            switches[index].setOn(switchPositions[index], animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwitches(false)
        aliasTextField.text = delegate!.connectionDetails.alias
    }
}

