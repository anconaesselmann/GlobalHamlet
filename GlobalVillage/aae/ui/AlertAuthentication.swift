import UIKit
import Foundation

class AlertAuthentication {
    private var successCallback:((Bool)->Void)?
    var authentication = Authentication()
    var api:ApiController!
    var url:String!
    init() {
        let dic = (UIApplication.sharedApplication().delegate as! AppDelegate).dic
        api = dic.build("api")! as! ApiController
        url = dic.get("url")! as! String
        
    }
    
    func attemptLogin(loginResultCallback:((Bool)->Void)) {
        let loginUrl = url + "/login"
        print("logging in with \(loginUrl)")
        api.request(loginUrl) {results in
            let loggedIn = self.authentication.processServerResponse(results)
            NSLog("Login status: \(loggedIn)")
            loginResultCallback(loggedIn)
        };
    }
    func loggOut(logoutResultCallback:((Bool)->Void)) {
        let loginUrl = url + "/login/logout"
        print("loggin out in with \(loginUrl)")
        api.request(loginUrl) {results in
            guard let loggedOut = (results.response as? Bool) else {
                logoutResultCallback(false)
                return
            }
            NSLog("Loggout status: \(loggedOut)")
            logoutResultCallback(loggedOut)
        };
    }
    func presentLoginAlert(email:String, successCallback:(Bool)->Void) {
        let title = "Login"
        let message = "Please enter your email and password."
        var emailTextField:UITextField!
        var passwordTextField:UITextField!
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "email"
            textField.keyboardType = UIKeyboardType.EmailAddress
            if email.characters.count > 0 {
                textField.text = email
            } else {
                let prefs = NSUserDefaults.standardUserDefaults()
                let email = prefs.stringForKey("loginEmail")
                textField.text = email
            }
            emailTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "password"
            textField.secureTextEntry = true
            passwordTextField = textField
        }
        let logInAction = UIAlertAction(title: "Log in", style: .Default) { [unowned self] (action) in
            self.successCallback = successCallback
            guard let email = emailTextField.text,
                let password = passwordTextField.text else {return}
            self.signInAction(email, password: password)
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setValue(email, forKey: "loginEmail")
        }
        alertController.addAction(logInAction)
        let createAction = UIAlertAction(title: "Create Account", style: .Default) {[unowned self] (action) in
            self.successCallback = successCallback
            self.presentSignupAlert();
        }
        alertController.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
        alertController.addAction(cancelAction)
        guard let topVC = UIApplication.topViewController() else {return}
        topVC.presentViewController(alertController, animated: true) {
            if emailTextField?.text?.characters.count > 0 {
                passwordTextField.becomeFirstResponder()
            }
        }
    }
    var supressSuccessMessage = false
    func presentLoginAlert(successCallback:(Bool)->Void) {
        presentLoginAlert("", successCallback: successCallback)
    }
    private func signInAction(email:String, password:String) {
        let loginUrl = "\(url)/login/submit"
        let uuid     = UIDevice().identifierForVendor!.UUIDString;
        let args     = [
            "userEmail":    email,
            "userPassword": password,
            "apiCaller":    "IOS9_\(uuid)"
        ]
        api.postRequest(loginUrl, arguments: args) {[weak self] results in
            guard self != nil else {return}
            let loggedIn = self!.authentication.processServerResponse(results)
            if loggedIn {
                if !self!.supressSuccessMessage {
                    self!.presentSuccessAlert()
                }
                if let successCallback = self!.successCallback {
                    successCallback(true)
                }
            } else {
                self!.presentFailureAlert(self!.authentication.errorMessage)
                if let successCallback = self!.successCallback {
                    successCallback(false)
                }
            }
        }
    }
    private func presentSuccessAlert() {
        let title = "Success"
        let message = "You successfully logged in"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
        alertController.addAction(OKAction)
        guard let topVC = UIApplication.topViewController() else {return}
        topVC.presentViewController(alertController, animated: true) {}
    }
    private func presentFailureAlert(message:String) {
        let title = "Failure"
        let message = message
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
        alertController.addAction(OKAction)
        guard let topVC = UIApplication.topViewController() else {return}
        topVC.presentViewController(alertController, animated: true) {}
    }
    private func presentSignupAlert() {
        let title = "Account Creation"
        let message = "Please enter a username, your email and a password."
        var userNameTextField:UITextField!
        var emailTextField:UITextField!
        var passwordTextField:UITextField!
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "username"
            textField.keyboardType = UIKeyboardType.EmailAddress
            userNameTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "email"
            textField.keyboardType = UIKeyboardType.EmailAddress
            emailTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "password"
            textField.secureTextEntry = true
            passwordTextField = textField
        }
        let createAction = UIAlertAction(title: "Create", style: .Default) { [unowned self] (action) in
            self.signUpAction(userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        }
        alertController.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
        alertController.addAction(cancelAction)
        guard let topVC = UIApplication.topViewController() else {return}
        topVC.presentViewController(alertController, animated: true) {}
        
    }
    

    private func signUpAction(username:String, email:String, password:String) {
        let args = ["userName": username, "userEmail": email, "userPassword": password, "lang": "eng"]
        let url: String  = "\(self.url)/signup/submit"
        
        api.postRequest(url, arguments: args) { results in
            print("Server result for signUpAction:\n")
            print(results)
            
            guard let success = results.response as? Bool else {
                NSLog("Server didn not respond with a boolean")
                return
            }
            guard success else {
                NSLog("Server could not create a new user")
                return
            }
            func showLoginAlert(alert: UIAlertAction!) -> Void {
                self.presentLoginAlert(email) { success in
                    
                }
            }
            let alert = UIAlertController(title: "Account created", message: "Prior to logging in for the first time, please check your email to complete the account creation.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: showLoginAlert))
            
            guard let topVC = UIApplication.topViewController() else {return}
            topVC.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func notLoggedInAlert(withLoginCallback callback:((Bool)->Void)) {
        NSLog("Not logged in")
        presentLoginAlert() {success in
            callback(success)
        }
    }
}