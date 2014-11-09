import UIKit

class InitiateQRViewController: DICViewController {
    var contractId: Int?
    var plainCode:  String?
    var qrCodeGenerator: CodeGeneratorProtocol!
    var web: WebProtocol!
    var url: String!
    var error = Error()
    
    @IBOutlet weak var contractIdLabel: UILabel!
    @IBOutlet weak var plainCodeLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if error.errorCode == 0 {
            let qrString = "\(plainCode!)\(String(contractId!))"
            contractIdLabel.text = String(contractId!)
            plainCodeLabel.text  = qrString
            qrCodeImage.image    = qrCodeGenerator.getImageFromString(qrString)
        } else {
            // TODO: handle error
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            url + "/contract/deleteinitiated",
            error: error
        ) as? Bool
        if error.errorCode == 0 && response != nil && response == true {
            println(response!)
        } else {
            println("Web request unsuccessful.")
        }
    }
}