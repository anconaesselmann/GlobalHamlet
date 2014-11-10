import UIKit

class InitiateViewController: DICTableViewController {
    var web: WebProtocol!
    var url: String!
    var error = Error()
    var connectionDetails = ConnectionDetails()
    
    @IBOutlet var switches: [UISwitch]!

    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    
    @IBOutlet weak var categorySelector: UISegmentedControl!
    @IBAction func categorySelectorValueChangedAction(sender: AnyObject) {
        setSwitches(true)
    }
    
    func setSwitches(animated: Bool) {
        switch categorySelector.selectedSegmentIndex {
        case 0:
            connectionDetails.setRestricted()
        case 1:
            connectionDetails.setCasual()
            
        case 2:
            connectionDetails.setFriend()
            
        default: break
        }
        let switchPositions:[Bool] = connectionDetails.getSwitchSettings()
        for index in 0...(switches.count - 1) {
            switches[index].setOn(switchPositions[index], animated: animated)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwitches(false)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "InitiateQRSegue" {
            _initiateQRSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
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
}

