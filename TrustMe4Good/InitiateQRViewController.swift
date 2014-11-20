import UIKit

class InitiateQRViewController: DICViewController, APIControllerDelegateProtocol {
    var contractId: Int?
    var plainCode:  String?
    var qrCodeGenerator: CodeGeneratorProtocol!
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func initWithArgs(args:[AnyObject]) {
        qrCodeGenerator = args[0] as CodeGeneratorProtocol
        api = args[1] as ApiController
        url = args[2] as String
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if results["errorCode"] as Int == 0 {
            contractId  = results["response"]?["connectionId"] as? Int
            plainCode   = results["response"]?["plainCode"]    as? String
            generateQrCode()
        } else {
            NSLog("Error creating qr code. The web request responded with error code " + (results["errorCode"] as String))
        }
    }
    
    func generateQrCode() {
        if qrCodeImage != nil && plainCode != nil {
            println("Generating Qr Code with id \(String(contractId!)) and string \(plainCode!)")
            let qrString      = "\(plainCode!)\(String(contractId!))"
            qrCodeImage.image = qrCodeGenerator.getImageFromString(qrString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateQrCode()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "DeleteInitContractsSegue" {
            _deleteInitContractsSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _deleteInitContractsSegue(segue: UIStoryboardSegue) {
        //api!.delegae = ?????
        api!.request(url + "/connection/deleteinitiated")
    }
}