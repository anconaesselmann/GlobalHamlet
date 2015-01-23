import UIKit
import Foundation

class SendMessageViewController: DICViewController, APIControllerDelegateProtocol {
    var connectionId:Int = 0
    var toString:String = ""
    var api:ApiController!
    var url:String!
    var error = Error()
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageBodyTextView: UITextView!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sendButton = UIBarButtonItem(image: UIImage(named: "navBar_send.png"), style: .Plain, target: self, action: "sendAction")
        let contactOptionsButton = UIBarButtonItem(image: UIImage(named: "navBar_options.png"), style: .Plain, target: self, action: "contactOptionsAction")
        navigationItem.setRightBarButtonItems([sendButton, contactOptionsButton], animated: true)
        
        self.navigationItem.title = toString
    }
    
    func sendAction() {
        sendEmail(
            connectionId,
            subject: subjectTextField!.text,
            messageBody: messageBodyTextView.text
        )
    }
    
    func contactOptionsAction() {
        performSegueWithIdentifier("contactOptionsSegue", sender: self)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "contactOptionsSegue" {
            _contactOptionsSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _contactOptionsSegue(segue: UIStoryboardSegue) {
        let vc:ContactOptionsTableViewController? = segue.destinationViewController as? ContactOptionsTableViewController
        if vc != nil {
            vc!.connectionId = connectionId
            println(connectionId)
        }
    }
}