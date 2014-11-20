import UIKit

class LoginViewController: DICViewController, APIControllerDelegateProtocol {
    var api: ApiController!
    var loggedIn: Bool = false
    var url: String!
    
    @IBOutlet weak var signInButton:  UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    

    @IBAction func signInAction(sender: AnyObject) {
        var email:String?    = self.emailTextField?.text
        var password:String? = self.passwordTextField?.text
        var uuid = UIDevice().identifierForVendor.UUIDString;
        
        var args = ["userEmail": email!, "userPassword": password!, "apiCaller": "IOS8_" + uuid]
        var url: String  = "\(self.url)/login/submit"
        
        api.delegate = self
        api.postRequest(url, arguments: args)
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if let response = results["response"] as? Bool {
            loggedIn = response
        } else {
            NSLog("Login post request came back with non-boolean reaponse")
            return
        }
        if loggedIn {
            println("logging in.")
            performSegueWithIdentifier("SegueToMain", sender: self)
        } else {
            loggedIn = false
            let errorMessage = "Error signing in."
            infoLabel!.text = errorMessage
            
            if let errorCode = results["errorCode"] as? String {
                NSLog(errorMessage + errorCode)
            } else {
                NSLog(errorMessage)
            }
        }
    }
    
}

