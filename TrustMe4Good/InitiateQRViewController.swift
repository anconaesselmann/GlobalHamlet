import UIKit

class InitiateQRViewController: DICViewController {
    var contractId: Int?
    var plainCode:  String?
    
    @IBOutlet weak var contractIdLabel: UILabel!
    @IBOutlet weak var plainCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contractIdLabel!.text = String(contractId!)
        plainCodeLabel!.text = plainCode
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}