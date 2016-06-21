import UIKit

public class SignUpViewController: DICViewController {
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override public func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        let args = ["userName": userNameTextField.text!, "userEmail": emailTextField.text!, "userPassword": passwordTextField.text!, "lang": "eng"]
        let url: String  = "\(self.url)/signup/submit"
        
        api.postRequest(url, arguments: args) { results in
            print("Result:\n")
            print(results)
            
            guard let success = results.response as? Bool else {
                NSLog("Server didn not respond with a boolean")
                return
            }
            guard success else {
                NSLog("Server could not create a new user")
                return
            }
            func performSegue(alert: UIAlertAction!) -> Void {
                self.performSegueWithIdentifier("SignUpToLogInSegue", sender: self)
            }
            let alert = UIAlertController(title: "Account created", message: "Prior to logging in for the first time, please check your email to complete the account creation.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: performSegue))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SignUpToLogInSegue" {
            let vc:LoginViewController? = segue.destinationViewController as? LoginViewController
            if vc != nil {
                vc!.email = emailTextField.text!
            }
        }
    }
}

