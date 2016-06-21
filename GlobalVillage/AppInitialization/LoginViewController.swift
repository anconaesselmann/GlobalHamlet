import UIKit

public class LoginViewController: DICViewController {
    var api: ApiController!
    var url: String!
    var email:String?
    var authentication = Authentication()
    
    @IBOutlet weak var signInButton:  UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override public func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if email != nil {
            emailTextField.text = email!
        }
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        let loginUrl = "\(url)/login/submit"
        let email    = emailTextField!.text
        let password = passwordTextField!.text
        let uuid     = UIDevice().identifierForVendor!.UUIDString;
        let args     = [
            "userEmail":    email!,
            "userPassword": password!,
            "apiCaller":    "IOS9_\(uuid)"
        ]
        
        api.postRequest(loginUrl, arguments: args) { results in
            let loggedIn = self.authentication.processServerResponse(results)
            if loggedIn {
                self.authentication.updateUI(self.dic.get("loginSegueStoryboardName") as! String, currentViewController: self)
            } else {
                self.infoLabel.text = self.authentication.errorMessage
            }
        }
    }
    

}

