import UIKit

class InitiateViewController: DICViewController {
    var web: WebProtocol!
    var url: String!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    
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
        if segue.identifier == "InitiateQRSegue" {
            _initiateQRSegue(segue)
        } else {
            println("unknown segue.")
        }
    }
    
    func _initiateQRSegue(segue: UIStoryboardSegue) {
        if let contractDetail = web?.postRequst(url + "/contract/initiate") {
            if let errorCode = contractDetail["errorCode"] as? Int {
                if errorCode != 0 {}
                println(errorCode)
            }
            if let response = contractDetail["response"] as? [String:AnyObject] {
                
                let contractId:Int?    = response["contractId"] as Int?
                let plainCode:String?  = response["plainCode"]  as String?
                if contractId? != nil && plainCode? != nil {
                    println(contractId!)
                    println(plainCode!)
                    let vc = segue.destinationViewController as InitiateQRViewController
                    vc.contractId = contractId
                    vc.plainCode  = plainCode
                }
            }
            //println(contractDetail)
        } else {
            println("Web request unsuccessful.")
        }
    }
}

