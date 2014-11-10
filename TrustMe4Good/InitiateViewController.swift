import UIKit

class InitiateViewController: DICTableViewController {
    var web: WebProtocol!
    var url: String!
    var error = Error()
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    
    @IBOutlet weak var categorySelector: UISegmentedControl!
    @IBAction func categorySelectorValueChangedAction(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
            case 0:
                showUserNameSwitch!.setOn(false, animated: true)
                showRealNameSwitch!.setOn(false, animated: true)
                useAliasSwitch!.setOn(true, animated: true)
            
        case 1:
            showUserNameSwitch!.setOn(true, animated: true)
            showRealNameSwitch!.setOn(false, animated: true)
            useAliasSwitch!.setOn(false, animated: true)
            
        case 2:
            showUserNameSwitch!.setOn(false, animated: true)
            showRealNameSwitch!.setOn(true, animated: true)
            useAliasSwitch!.setOn(false, animated: true)
            
        default: break
        }
        println(sender.selectedSegmentIndex)
    }
    @IBOutlet weak var showUserNameSwitch: UISwitch!
    @IBOutlet weak var showRealNameSwitch: UISwitch!
    @IBOutlet weak var useAliasSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

