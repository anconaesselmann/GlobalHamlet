import UIKit

class SignUpViewController: DICViewController, APIControllerDelegateProtocol {
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUpAction(sender: AnyObject) {
        var args = ["userName": userNameTextField.text!, "userEmail": emailTextField.text!, "userPassword": passwordTextField.text!, "lang": "eng"]
        var url: String  = "\(self.url)/signup/submit"
        
        api.delegate = self
        api.postRequest(url, arguments: args)
    }
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        api.delegate = self
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        let success = results["response"] as Bool
        if success {
            func performSegue(alert: UIAlertAction!) -> Void {
                performSegueWithIdentifier("SignUpToLogInSegue", sender: self)
            }
            var alert = UIAlertController(title: "Account created", message: "Prior to logging in for the first time, please check your email to complete the account creation.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: performSegue))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            NSLog("Error creating user")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "SignUpToLogInSegue" {
            let vc:LoginViewController? = segue.destinationViewController as? LoginViewController
            if vc != nil {
                vc!.email = emailTextField.text!
            }
        }
    }
}

