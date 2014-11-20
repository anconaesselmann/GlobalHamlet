import UIKit
import Foundation

class SendMessageViewController: DICViewController, APIControllerDelegateProtocol {
    var connectionId:Int = 0
    var toString:String = ""
    var api:ApiController!
    var url:String!
    var error = Error()
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageBodyTextView: UITextView!
    
    @IBAction func sendAction(sender: AnyObject) {
        sendEmail(
            connectionId,
            subject: subjectTextField!.text,
            messageBody: messageBodyTextView.text
        )
    }
    @IBOutlet weak var sendAction: UIBarButtonItem!
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is ApiController)
        assert(args[1] is String)
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toLabel.text = toString
    }
    
    func sendEmail(id:Int, subject:String, messageBody:String) -> Bool {
        if api != nil && url != nil {
            let arguments:[String: String] = ["id": String(id), "subject": subject, "body": messageBody]
            
            api!.delegate = self
            api!.postRequest(url + "/message/email", arguments: arguments)
        }
        return false
    }
    func didReceiveAPIResults(results: NSDictionary) {
        println("Email sending response:")
        println(results)
        performSegueWithIdentifier("EmailToMainSegue", sender: nil)
    }
}