import UIKit
import Foundation

class SendMessageViewController: DICViewController {
    var connectionId:Int = 0
    var toString:String = ""
    var web:WebProtocol!
    var url:String!
    var error = Error()
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageBodyTextView: UITextView!
    
    @IBAction func sendAction(sender: AnyObject) {
        let success = sendEmail(
            connectionId,
            subject: subjectTextField!.text,
            messageBody: messageBodyTextView.text
        )
    }
    @IBOutlet weak var sendAction: UIBarButtonItem!
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toLabel.text = toString
    }
    
    func sendEmail(id:Int, subject:String, messageBody:String) -> Bool {
        if web != nil && url != nil {
            let arguments:[String: String] = ["id": String(id), "subject": subject, "body": messageBody]
            let response: Bool? = web!.getResponseWithError(
                url + "/message/email",
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