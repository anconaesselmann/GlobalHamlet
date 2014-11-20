import UIKit

class InitiateQRViewController: DICViewController, APIControllerDelegateProtocol {
    var contractId: Int?
    var plainCode:  String?
    var qrCodeGenerator: CodeGeneratorProtocol!
    var web: WebProtocol!
    var url: String!
    var error = Error()
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 3)
        assert(args[0] is CodeGeneratorProtocol)
        assert(args[1] is WebProtocol)
        assert(args[2] is String)
        qrCodeGenerator = args[0] as CodeGeneratorProtocol
        web = args[1] as WebProtocol
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
        if error.errorCode != 0 {
            return
        }
        let response: Bool? = web!.getResponseWithError(
            url + "/connection/deleteinitiated",
            error: error
            ) as? Bool
        if error.errorCode == 0 && response != nil && response == true {
            println(response!)
        } else {
            println("Web request unsuccessful.")
        }
    }
}