import UIKit

class InitiateViewController: DICTableViewController {
    var api: ApiController!
    var url: String!
    var connectionDetails:SettingsProtocol!
    var delegate: ReciprocateViewController! // TODO: Remove this. Remove also from where it is set.
    
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    @IBAction func aliasUdatedAction(sender: AnyObject) {
        if connectionDetails.getSwitch("show_alias") {
            connectionDetails.setString("alias", value: identityTextField.text)
        }
    }

    @IBAction func saveAction(sender: AnyObject) {
        if delegate?.codeAndIdTuple? != nil {
            performSegueWithIdentifier("ViewReciprocationResultSegue", sender: nil)
        } else {
            performSegueWithIdentifier("InitiateQRSegue", sender: nil)
        }
    }
    
    @IBAction func categorySelectorValueChangedAction(sender: AnyObject) {
        initSwitches(true)
    }
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    func initSwitches(animated: Bool) {
        switch categorySelector.selectedSegmentIndex {
        case 0: connectionDetails.setSwitches(
            SharingSettingsRestricted().getButtons("identity")
        )
        case 1: connectionDetails.setSwitches(
            SharingSettingsCasual().getButtons("identity")
            )
        case 2: connectionDetails.setSwitches(
            SharingSettingsFriend().getButtons("identity")
            )
        default: break
        }
        setIdentityTextField()
    }
    
    func setIdentityTextField() {
        if connectionDetails.getSwitch("show_alias") {
            identityTextField.text = connectionDetails.getString("alias")
            identityTextField.enabled = true
            identityTextField.becomeFirstResponder()
            identityTextField.borderStyle = UITextBorderStyle.RoundedRect
        } else {
            if connectionDetails.getSwitch("show_user_name") {
                identityTextField.text = "user name"
            } else if connectionDetails.getSwitch("show_real_name") {
                identityTextField.text = "real name"
            }
            identityTextField.enabled = false
            identityTextField.borderStyle = UITextBorderStyle.None
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionDetails = SharingSettings()
        connectionDetails.setString("alias", value:"")
        initSwitches(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "InitiateQRSegue" {
            _initiateQRSegue(segue)
            println(connectionDetails?.getJson())
        } else if segue.identifier? == "ViewReciprocationResultSegue" {
            _submitReciprocate(segue)
            println(connectionDetails?.getJson())
        } else if segue.identifier?  == "IdentitySharingSegue" {
            _identitySharingSegue(segue)
        } else if segue.identifier? == "CommunicationSharingSegue" {
            _communicationSharingSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _identitySharingSegue(segue: UIStoryboardSegue) {
        let vc:IdentitySharingViewController? = segue.destinationViewController as? IdentitySharingViewController
        if vc != nil {
            vc!.delegate = self
        }
    }
    func _communicationSharingSegue(segue: UIStoryboardSegue) {
        let vc:CommunicationSharingViewController? = segue.destinationViewController as? CommunicationSharingViewController
        if vc != nil {
            vc!.delegate = self
        }
    }
    
    func _submitReciprocate(segue: UIStoryboardSegue) {
        let detailsString:String = connectionDetails!.getJson()
        println("in segue:\n\n")
        println(detailsString)
        
        let id:Int?      = delegate!.codeAndIdTuple.id
        let code:String? = delegate!.codeAndIdTuple.code
        let vc:ViewOtherDetailViewController? = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? ViewOtherDetailViewController
        if id != nil && code != nil && vc != nil {
            let arguments:[String: String] = ["connectionId": String(id!), "plainCode": code!, "details": detailsString]
            
            api.delegate = vc!
            api.postRequest(url + "/connection/reciprocate", arguments: arguments);
        } else {
            NSLog("id, code aor vc where nil")
        }
    }
    
    func _initiateQRSegue(segue: UIStoryboardSegue) {
        let detailsString:String = connectionDetails!.getJson()
        println("in segue:\n\n")
        println(detailsString)
        let arguments:[String: String] = ["details": detailsString]
        
        let vc:InitiateQRViewController? = segue.destinationViewController as? InitiateQRViewController
        if vc == nil {
            NSLog("Error getting destination view controller.")
        }
        api.delegate = vc!
        api.postRequest(url + "/connection/initiate", arguments: arguments)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.row) {
            case 0: return 94
            default: return 44
        }
    }
}

