import UIKit
import Foundation

class ReciprocateViewController: DICViewController {
    var web: WebProtocol!
    var url: String!
    var error = Error()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0]  as WebProtocol
        url = args[1]  as String
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        let id: Int?      = idTextField?.text.toInt()
        let code: String? = codeTextField?.text
        sendCode(id, code: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendCode(id:Int?, code:String?) -> Bool {
        if error.errorCode != 0 {
            return false
        }
        if id != nil && code != nil {
            let arguments:[String: String] = ["contractId": String(id!), "plainCode": code!]
            let response: Bool? = web!.getResponseWithError(
                url + "/contract/reciprocate",
                arguments: arguments,
                error: error
            ) as? Bool
            if error.errorCode == 0 && response != nil && response == true {
                println(response!)
                return true
            } else {
                println("Web request unsuccessful.")
            }
        }
        return false
    }
}

