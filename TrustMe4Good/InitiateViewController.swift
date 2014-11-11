import UIKit

class InitiateViewController: DICTableViewController {
    var web: WebProtocol!
    var url: String!
    var error = Error()
    var connectionDetails:Settings!
    
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    @IBAction func aliasUdatedAction(sender: AnyObject) {
        if connectionDetails.getSwitch("show_alias") {
            connectionDetails.setString("alias", value: identityTextField.text)
        }
    }
    
    @IBAction func categorySelectorValueChangedAction(sender: AnyObject) {
        initSwitches(true)
    }
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
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
        } else if segue.identifier?  == "IdentitySharingSegue" {
            _identitySharingSegue(segue)
        }else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _identitySharingSegue(segue: UIStoryboardSegue) {
        let vc:IdentitySharingViewController? = segue.destinationViewController as? IdentitySharingViewController
        if vc != nil {
            vc!.selectedCategory = categorySelector.selectedSegmentIndex
            vc!.delegate = self
        }
    }
    
    func _initiateQRSegue(segue: UIStoryboardSegue) {
        let response: [String: AnyObject]? = web!.getResponseWithError(
            url + "/contract/initiate",
            error: error
        ) as? [String: AnyObject]
        let vc:InitiateQRViewController? = segue.destinationViewController as? InitiateQRViewController
        if error.errorCode == 0 {
            let contractId:Int?   = response?["contractId"] as? Int
            let plainCode:String? = response?["plainCode"]  as? String
            if contractId != nil && plainCode != nil && vc != nil {
                vc!.contractId = contractId
                vc!.plainCode  = plainCode
                println(contractId!)
                println(plainCode!)
                return
            } else {
                error.errorCode    = 1108141605
                error.errorMessage = "Contract not a dictionary."
            }
        }
        if vc != nil {
            vc!.error = error
        }
        println(error.errorMessage)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}

