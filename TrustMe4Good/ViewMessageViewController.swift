import UIKit
import Foundation

class ViewMessageViewController: DICViewController, UpdateDelegateProtocol {
    var messageId:Int?;
    var message:Message!
    var api: ApiController!
    var url: String!
    var loadingView:LoadingIndicator!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        loadingView = LoadingIndicator(del: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message = Message()
        message!.delegate = self
        
        getMessage()
    }
    
    func updateDelegate() {
        subjectLabel.text = message!.subject
        messageLabel.text = message!.message
        
        println("Printing message:")
        println(message!)
        loadingView.stop()
    }
    
    func getMessage() {
        if messageId != nil && message != nil {
            let arguments:[String: String] = ["id": String(messageId!)]
            api.delegate = message!
            api.postRequest(
                url + "/message/get",
                arguments: arguments
            )
            loadingView.start()
        }
    }
}