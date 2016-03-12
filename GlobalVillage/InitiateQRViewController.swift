import UIKit

class InitiateQRViewController: DICViewController, APIControllerDelegateProtocol {
    var initConnectionId: Int?
    var connectionId: Int?
    var plainCode:  String?
    var qrCodeGenerator: CodeGeneratorProtocol!
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func initWithArgs(args:[AnyObject]) {
        qrCodeGenerator = args[0] as! CodeGeneratorProtocol
        api = args[1] as! ApiController
        url = args[2] as! String
        api.delegate = self
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if results["errorCode"] as! Int == 0 {
            if initConnectionId == nil {
                initConnectionId  = results["response"]?.objectForKey("connectionId") as? Int
                plainCode   = results["response"]?.objectForKey("plainCode") as? String
                generateQrCode()
            } else {
                // A code has already been generated, which means this api result is coming from checkIfResponded closure
                let testId:Int? = results["response"] as? Int
                if testId != nil && testId > 0 {
                    connectionId  = testId
                    performSegueWithIdentifier("ViewInitiateResultSegue", sender: nil)
                } else {
                    checkIfResponded()
                }
            }
        } else {
            let errorCode:String? = results["errorCode"] as? String
            NSLog("Error initiating connection. The web request responded with error code:")
            print(errorCode)
        }
    }
    
    func generateQrCode() {
        if qrCodeImage != nil && plainCode != nil && initConnectionId != nil {
            print("Generating Qr Code with id \(String(initConnectionId!)) and string \(plainCode!)")
            let qrString      = "\(plainCode!)\(String(initConnectionId!))"
            qrCodeImage.image = qrCodeGenerator.getImageFromString(qrString)
            checkIfResponded()
        }
    }
    
    func checkIfResponded() {
        let sec = 1.0
        let delay = dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(sec * Double(NSEC_PER_SEC))
        )
        dispatch_after(delay, dispatch_get_main_queue(), {
            print("delayed block called")
            let args:[String: String] = ["initConnectionId": String(self.initConnectionId!)]
            self.api!.postRequest(self.url + "/connection/check_init_response", arguments: args)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateQrCode()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "DeleteInitContractsSegue" {
            _deleteInitConnectionSegue(segue)
        } else if segue.identifier == "ViewInitiateResultSegue" {
            _viewInitiateResultSegue(segue)
        } else {
            print("unknown segue: \(segue.identifier)")
        }
    }
    
    func _deleteInitConnectionSegue(segue: UIStoryboardSegue) {
        api!.delegate = nil
        api!.request(url + "/connection/deleteinitiated")
    }
    
    func _viewInitiateResultSegue(segue: UIStoryboardSegue) {
        let vc:ViewOtherDetailViewController? = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? ViewOtherDetailViewController
        if vc != nil && connectionId != nil {
            vc!.connectionId = connectionId!
        }
    }
}